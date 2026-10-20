package com.ruoyi.iot.plugin.bacnet;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.DiscoveredDataPoint;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import com.ruoyi.iot.metadata.Converter;
import com.serotonin.bacnet4j.LocalDevice;
import com.serotonin.bacnet4j.RemoteDevice;
import com.serotonin.bacnet4j.exception.BACnetException;
import com.serotonin.bacnet4j.npdu.ip.IpNetwork;
import com.serotonin.bacnet4j.npdu.ip.IpNetworkBuilder;
import com.serotonin.bacnet4j.transport.DefaultTransport;
import com.serotonin.bacnet4j.type.Encodable;
import com.serotonin.bacnet4j.type.constructed.SequenceOf;
import com.serotonin.bacnet4j.type.enumerated.ObjectType;
import com.serotonin.bacnet4j.type.enumerated.PropertyIdentifier;
import com.serotonin.bacnet4j.type.primitive.CharacterString;
import com.serotonin.bacnet4j.type.primitive.ObjectIdentifier;
import com.serotonin.bacnet4j.type.primitive.UnsignedInteger;
import com.serotonin.bacnet4j.util.DiscoveryUtils;
import com.serotonin.bacnet4j.util.RemoteDeviceDiscoverer;
import com.serotonin.bacnet4j.util.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * 基于 BACnet4J 6.1.1 的 BACnet/IP 客户端型边缘适配器。
 *
 * <p>BACnet/IP 使用无连接 UDP；这里的“已连接”表示本地 BACnet 设备与 UDP 传输已成功初始化。
 * 远端设备按点位中的 deviceInstance 定向发现并缓存。</p>
 */
public class BacnetEdgeAdapter extends EdgeAdapter {

    private static final Logger log = LoggerFactory.getLogger(BacnetEdgeAdapter.class);
    private static final int MAX_DISCOVERED_POINTS = 2000;
    private static final int PORT = IpNetwork.DEFAULT_PORT;
    private static final int REQUEST_TIMEOUT = 6000;
    private static final int SEGMENT_TIMEOUT = 1500;
    private static final int RETRIES = 2;
    private static final int RECONNECT_INTERVAL = 30000;
    private static final int DISCOVERY_TIMEOUT = 3000;

    private final Object lifecycleLock = new Object();
    private final AtomicBoolean connected = new AtomicBoolean(false);
    private final Map<Integer, RemoteDevice> remoteDevices = new ConcurrentHashMap<>();

    private volatile LocalDevice localDevice;
    private volatile Disposable refreshDisposable;
    private volatile Disposable detectionDisposable;
    private volatile Disposable discoveryDisposable;
    private volatile List<BacnetPoint> points = List.of();

    private int localDeviceInstance;
    private String bindAddress = "0.0.0.0";
    private String broadcastAddress = "255.255.255.255";
    private int subnetPrefixLength;
    private int pollingInterval = 5000;
    private Set<Integer> deviceInstances = Set.of();

    @Override
    public void init(EdgeDeviceConfig edgeDevice) {
        JSONObject config = JSON.parseObject(edgeDevice.getConfiguration());
        if (config == null) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 BACnet 配置");
        }

        localDeviceInstance = requiredInstance(config, "localDeviceInstance");
        NetworkBinding binding = resolveNetworkBinding(config.getString("localIp"));
        bindAddress = binding.bindAddress();
        broadcastAddress = binding.broadcastAddress();
        subnetPrefixLength = binding.prefixLength();
        pollingInterval = positiveInt(config, 5000, "pollingInterval");
        deviceInstances = parseDeviceInstances(config);

        initializePoints();
        log.info("BACnet/IP 边缘网关 {} 初始化成功，localDeviceInstance:{},bind:{}:{},broadcast:{}/{},points:{}",
                edgeDevice.getName(), localDeviceInstance, bindAddress, PORT, broadcastAddress,
                subnetPrefixLength, points.size());
    }

    private void initializePoints() {
        List<BacnetPoint> valid = new ArrayList<>();
        for (Map.Entry<String, DataPoint> entry : getDataPointMap().entrySet()) {
            try {
                BacnetPoint point = parsePoint(entry.getValue());
                point.setId(entry.getKey());
                point.validateAndPrepare();
                valid.add(point);
            } catch (Exception e) {
                log.warn("BACnet/IP 边缘网关 {} 点位 {} 配置无效，已跳过：{}",
                        getEdgeDeviceName(), entry.getKey(), rootMessage(e));
            }
        }
        points = List.copyOf(valid);
    }

    BacnetPoint parsePoint(DataPoint dataPoint) {
        if (dataPoint.getConfig() == null || dataPoint.getConfig().isBlank()) {
            throw new IllegalArgumentException("点位配置为空");
        }
        JSONObject object = JSON.parseObject(dataPoint.getConfig());
        BacnetPoint point = new BacnetPoint();
        point.setDeviceInstance(requiredInstance(object, "deviceInstance"));
        point.setObjectType(object.getString("objectType"));
        point.setObjectInstance(requiredInstance(object, "objectInstance"));
        point.setWritePriority(nullableInteger(object, "writePriority"));
        return point;
    }

    @Override
    public void enable() {
        synchronized (lifecycleLock) {
            if (isEnabled()) {
                return;
            }
            setEnabledStatus(true);
        }
        if (connect()) {
            online();
            startDataRefresh();
            startPointDiscovery();
        } else {
            offline();
        }
        startDetectionLoop();
    }

    @Override
    public void disable() {
        setEnabledStatus(false);
        stopDetectionLoop();
        stopPointDiscovery();
        disconnect();
    }

    @Override
    public void online() {
        if (!isOnline()) {
            setOnlineStatus(true);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOnline(getEdgeDeviceId());
            }
        }
    }

    @Override
    public void offline() {
        if (isOnline()) {
            setOnlineStatus(false);
            if (getRuntimeContext() != null) {
                getRuntimeContext().publishOffline(getEdgeDeviceId());
            }
        }
    }

    @Override
    public boolean connect() {
        synchronized (lifecycleLock) {
            if (isConnected()) {
                return true;
            }
            closeConnectionQuietly();
            LocalDevice created = null;
            try {
                IpNetwork network = new IpNetworkBuilder()
                        .withLocalBindAddress(bindAddress)
                        .withBroadcast(broadcastAddress, subnetPrefixLength)
                        .withPort(PORT)
                        .withReuseAddress(true)
                        .build();
                DefaultTransport transport = new DefaultTransport(network);
                transport.setTimeout(REQUEST_TIMEOUT);
                transport.setSegTimeout(SEGMENT_TIMEOUT);
                transport.setRetries(RETRIES);
                created = new LocalDevice(localDeviceInstance, transport);
                created.initialize();
                localDevice = created;
                connected.set(true);
                log.info("BACnet/IP 边缘网关 {} 已启动本地设备 {}，监听 {}:{}",
                        getEdgeDeviceName(), localDeviceInstance, bindAddress, PORT);
                return true;
            } catch (Exception e) {
                if (created != null) {
                    try {
                        created.terminate();
                    } catch (Exception closeError) {
                        log.debug("BACnet/IP 本地设备启动失败后的清理异常", closeError);
                    }
                }
                log.error("BACnet/IP 边缘网关 {} 启动失败：{}", getEdgeDeviceName(), rootMessage(e), e);
                connected.set(false);
                return false;
            }
        }
    }

    @Override
    public boolean disconnect() {
        stopDataRefresh();
        stopPointDiscovery();
        synchronized (lifecycleLock) {
            closeConnectionQuietly();
        }
        offline();
        return true;
    }

    private void closeConnectionQuietly() {
        connected.set(false);
        remoteDevices.clear();
        LocalDevice current = localDevice;
        localDevice = null;
        if (current != null) {
            try {
                current.terminate();
            } catch (Exception e) {
                log.warn("BACnet/IP 边缘网关 {} 关闭失败：{}", getEdgeDeviceName(), rootMessage(e));
            }
        }
    }

    @Override
    public boolean isConnected() {
        LocalDevice current = localDevice;
        return connected.get() && current != null && current.isInitialized();
    }

    @Override
    public DataPoint readDataPoint(DataPoint dataPoint) {
        try {
            BacnetPoint point = parsePoint(dataPoint);
            point.setId(dataPoint.getId());
            point.validateAndPrepare();
            readPoint(dataPoint, point);
        } catch (Exception e) {
            log.error("BACnet/IP 边缘网关 {} 读取点位 {} 失败：{}",
                    getEdgeDeviceName(), dataPoint.getId(), rootMessage(e), e);
        }
        return dataPoint;
    }

    @Override
    public List<DataPoint> readDataPoints(List<DataPoint> requestedPoints) {
        List<DataPoint> result = new ArrayList<>(requestedPoints.size());
        for (DataPoint point : requestedPoints) {
            result.add(readDataPoint(point));
        }
        return result;
    }

    private Object readPoint(DataPoint dataPoint, BacnetPoint point) throws BACnetException {
        LocalDevice current = requireLocalDevice();
        RemoteDevice remote = resolveRemoteDevice(current, point.getDeviceInstance());
        Encodable encoded = RequestUtils.readProperty(current, remote,
                point.getParsedObjectIdentifier(), PropertyIdentifier.presentValue, null);
        String platformType = dataPoint.getType() == null ? null : dataPoint.getType().getType();
        Object value = BacnetValueConverter.fromBacnet(encoded, platformType);
        dataPoint.updateValue(value);
        dataPoint.setLastTime(new Date());
        return value;
    }

    private RemoteDevice resolveRemoteDevice(LocalDevice current, int instance) throws BACnetException {
        RemoteDevice cached = remoteDevices.get(instance);
        if (cached != null) {
            return cached;
        }
        RemoteDevice discovered = current.getRemoteDeviceBlocking(instance, REQUEST_TIMEOUT);
        DiscoveryUtils.getExtendedDeviceInformation(current, discovered);
        remoteDevices.put(instance, discovered);
        return discovered;
    }

    @Override
    public DataWriteResult writeDataPoint(String pointId, Object value) {
        DataPoint dataPoint = getDataPointMap().get(pointId);
        if (dataPoint == null) {
            return DataWriteResult.of(false, "下置点位缓存中不存在，请重启边缘网关设备");
        }
        if (!isConnected()) {
            return DataWriteResult.of(false, "BACnet/IP 本地设备未启动");
        }
        try {
            BacnetPoint point = parsePoint(dataPoint);
            point.setId(pointId);
            point.validateAndPrepare();
            Object normalized = dataPoint.getType() instanceof Converter<?>
                    ? ((Converter<?>) dataPoint.getType()).convert(value) : value;
            Encodable encoded = BacnetValueConverter.toBacnet(normalized, point);
            LocalDevice current = requireLocalDevice();
            RemoteDevice remote = resolveRemoteDevice(current, point.getDeviceInstance());
            UnsignedInteger priority = point.getWritePriority() == null
                    ? null : new UnsignedInteger(point.getWritePriority());
            RequestUtils.writeProperty(current, remote, point.getParsedObjectIdentifier(),
                    PropertyIdentifier.presentValue, null, encoded, priority);
            dataPoint.updateValue(normalized);
            dataPoint.setLastTime(new Date());
            return DataWriteResult.of(true, "点位下置成功");
        } catch (Exception e) {
            log.error("BACnet/IP 边缘网关 {} 点位 {} 下置失败：{}",
                    getEdgeDeviceName(), pointId, rootMessage(e), e);
            return DataWriteResult.of(false, "点位下置失败：" + rootMessage(e));
        }
    }

    @Override
    public Map<String, DataWriteResult> writeDataPoints(Map<String, Object> pointValues) {
        Map<String, DataWriteResult> results = new LinkedHashMap<>();
        pointValues.forEach((id, value) -> results.put(id, writeDataPoint(id, value)));
        return results;
    }

    @Override
    public void startDataRefresh() {
        stopDataRefresh();
        refreshDisposable = Flux.interval(Duration.ZERO, Duration.ofMillis(pollingInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> Mono.fromRunnable(this::refreshPoints).subscribeOn(virtualThreadScheduler))
                .onErrorContinue((error, ignored) ->
                        log.error("BACnet/IP 边缘网关 {} 数据刷新异常", getEdgeDeviceName(), error))
                .subscribe();
    }

    private void refreshPoints() {
        if (!isEnabled() || !isConnected()) {
            return;
        }
        Map<String, DataPoint> changed = new HashMap<>();
        for (BacnetPoint point : points) {
            DataPoint dataPoint = getDataPointMap().get(point.getId());
            if (dataPoint == null) {
                continue;
            }
            Object previous = dataPoint.getValue();
            try {
                Object value = readPoint(dataPoint, point);
                if (!Objects.deepEquals(previous, value)) {
                    changed.put(point.getId(), dataPoint.clone());
                }
            } catch (Exception e) {
                log.warn("BACnet/IP 边缘网关 {} 读取点位 {}({})失败：{}",
                        getEdgeDeviceName(), point.getId(), point.stableKey(), rootMessage(e));
            }
        }
        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(getEdgeDeviceId(), changed);
        }
    }

    @Override
    public void stopDataRefresh() {
        Disposable refresh = refreshDisposable;
        refreshDisposable = null;
        if (refresh != null) {
            refresh.dispose();
        }
    }

    @Override
    public void startDetectionLoop() {
        stopDetectionLoop();
        detectionDisposable = Flux.interval(Duration.ofMillis(RECONNECT_INTERVAL), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> Mono.fromRunnable(this::detectAndReconnect).subscribeOn(virtualThreadScheduler))
                .onErrorContinue((error, ignored) ->
                        log.error("BACnet/IP 边缘网关 {} 连接检测异常", getEdgeDeviceName(), error))
                .subscribe();
    }

    private void detectAndReconnect() {
        if (!isEnabled()) {
            return;
        }
        if (isConnected()) {
            online();
            return;
        }
        offline();
        synchronized (lifecycleLock) {
            closeConnectionQuietly();
        }
        if (connect()) {
            online();
            startDataRefresh();
            startPointDiscovery();
        }
    }

    @Override
    public void stopDetectionLoop() {
        Disposable detection = detectionDisposable;
        detectionDisposable = null;
        if (detection != null) {
            detection.dispose();
        }
    }

    private void startPointDiscovery() {
        stopPointDiscovery();
        if (getRuntimeContext() == null) {
            return;
        }
        discoveryDisposable = Mono.fromRunnable(this::discoverAndRegisterPoints)
                .subscribeOn(virtualThreadScheduler)
                .subscribe(null, error -> log.warn("BACnet/IP 边缘网关 {} 自动发现点位失败：{}",
                        getEdgeDeviceName(), rootMessage(error), error));
    }

    private void stopPointDiscovery() {
        Disposable discovery = discoveryDisposable;
        discoveryDisposable = null;
        if (discovery != null) {
            discovery.dispose();
        }
    }

    private void discoverAndRegisterPoints() {
        LocalDevice current = localDevice;
        if (!isConnected() || current == null) {
            return;
        }
        List<RemoteDevice> discoveredDevices;
        try (RemoteDeviceDiscoverer discoverer = current.startRemoteDeviceDiscovery()) {
            Thread.sleep(DISCOVERY_TIMEOUT);
            discoveredDevices = discoverer.getRemoteDevices();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return;
        }

        List<DiscoveredDataPoint> discoveredPoints = new ArrayList<>();
        for (RemoteDevice remote : discoveredDevices) {
            if (!deviceInstances.isEmpty() && !deviceInstances.contains(remote.getInstanceNumber())) {
                continue;
            }
            try {
                DiscoveryUtils.getExtendedDeviceInformation(current, remote);
                remoteDevices.put(remote.getInstanceNumber(), remote);
                discoverDevicePoints(current, remote, discoveredPoints);
            } catch (Exception e) {
                log.warn("BACnet/IP 边缘网关 {} 读取远端设备 {} 对象列表失败：{}",
                        getEdgeDeviceName(), remote.getInstanceNumber(), rootMessage(e));
            }
            if (discoveredPoints.size() >= MAX_DISCOVERED_POINTS) {
                break;
            }
        }

        List<DataPoint> registered = registerDiscoveredDataPoints(discoveredPoints);
        if (!registered.isEmpty()) {
            initializePoints();
        }
        log.info("BACnet/IP 边缘网关 {} 发现 {} 台设备、{} 个可采集对象，同步 {} 个点位",
                getEdgeDeviceName(), discoveredDevices.size(), discoveredPoints.size(), registered.size());
    }

    private void discoverDevicePoints(LocalDevice current, RemoteDevice remote,
            List<DiscoveredDataPoint> target) throws BACnetException {
        SequenceOf<ObjectIdentifier> objectList = RequestUtils.getObjectList(current, remote);
        for (ObjectIdentifier objectIdentifier : objectList) {
            if (objectIdentifier.getObjectType().equals(ObjectType.device)) {
                continue;
            }
            String type = platformType(objectIdentifier.getObjectType());
            if (type == null) {
                continue;
            }
            String name = readObjectName(current, remote, objectIdentifier);
            target.add(toDiscoveredDataPoint(remote.getInstanceNumber(), objectIdentifier, name));
            if (target.size() >= MAX_DISCOVERED_POINTS) {
                log.warn("BACnet/IP 边缘网关 {} 自动发现达到 {} 个点位上限，其余对象已忽略",
                        getEdgeDeviceName(), MAX_DISCOVERED_POINTS);
                return;
            }
        }
    }

    private static BacnetPoint discoveredPoint(int deviceInstance, ObjectIdentifier objectIdentifier) {
        BacnetPoint point = new BacnetPoint();
        point.setDeviceInstance(deviceInstance);
        point.setObjectType(toConfigObjectType(objectIdentifier.getObjectType()));
        point.setObjectInstance(objectIdentifier.getInstanceNumber());
        point.validateAndPrepare();
        return point;
    }

    static DiscoveredDataPoint toDiscoveredDataPoint(
            int deviceInstance, ObjectIdentifier objectIdentifier, String objectName) {
        String type = platformType(objectIdentifier.getObjectType());
        if (type == null) {
            throw new IllegalArgumentException("不支持自动创建的 BACnet 对象类型："
                    + objectIdentifier.getObjectType());
        }
        BacnetPoint point = discoveredPoint(deviceInstance, objectIdentifier);
        JSONObject config = new JSONObject();
        config.put("deviceInstance", point.getDeviceInstance());
        config.put("objectType", point.getObjectType());
        config.put("objectInstance", point.getObjectInstance());
        String name = objectName == null || objectName.isBlank()
                ? objectIdentifier.toString() : objectName.trim();
        return new DiscoveredDataPoint(
                point.stableKey(),
                deviceInstance + "/" + name,
                type,
                isWritableObject(objectIdentifier.getObjectType()) ? "w" : "r",
                config.toJSONString());
    }

    private static String toConfigObjectType(ObjectType type) {
        String bacnetName = ObjectType.nameForId(type.intValue());
        if (bacnetName == null) {
            return Integer.toString(type.intValue());
        }
        StringBuilder result = new StringBuilder();
        boolean upperNext = false;
        for (int i = 0; i < bacnetName.length(); i++) {
            char current = bacnetName.charAt(i);
            if (current == '-') {
                upperNext = true;
            } else if (upperNext) {
                result.append(Character.toUpperCase(current));
                upperNext = false;
            } else {
                result.append(current);
            }
        }
        return result.toString();
    }

    private static String readObjectName(LocalDevice current, RemoteDevice remote, ObjectIdentifier objectIdentifier) {
        try {
            Encodable value = RequestUtils.readProperty(current, remote, objectIdentifier,
                    PropertyIdentifier.objectName, null);
            if (value instanceof CharacterString text && !text.getValue().isBlank()) {
                return text.getValue();
            }
        } catch (Exception ignored) {
            // Object identifier is a stable fallback when objectName is unavailable.
        }
        return objectIdentifier.toString();
    }

    private static String platformType(ObjectType type) {
        if (type.equals(ObjectType.analogInput) || type.equals(ObjectType.analogOutput)
                || type.equals(ObjectType.analogValue)) {
            return "float";
        }
        if (type.equals(ObjectType.largeAnalogValue)) {
            return "double";
        }
        if (type.equals(ObjectType.binaryInput) || type.equals(ObjectType.binaryOutput)
                || type.equals(ObjectType.binaryValue)) {
            return "boolean";
        }
        if (type.equals(ObjectType.multiStateInput) || type.equals(ObjectType.multiStateOutput)
                || type.equals(ObjectType.multiStateValue) || type.equals(ObjectType.integerValue)) {
            return "int";
        }
        if (type.equals(ObjectType.positiveIntegerValue) || type.equals(ObjectType.accumulator)
                || type.equals(ObjectType.pulseConverter)) {
            return "long";
        }
        if (type.equals(ObjectType.characterstringValue)) {
            return "string";
        }
        return null;
    }

    private static boolean isWritableObject(ObjectType type) {
        return type.equals(ObjectType.analogOutput) || type.equals(ObjectType.analogValue)
                || type.equals(ObjectType.binaryOutput) || type.equals(ObjectType.binaryValue)
                || type.equals(ObjectType.multiStateOutput) || type.equals(ObjectType.multiStateValue)
                || type.equals(ObjectType.integerValue) || type.equals(ObjectType.positiveIntegerValue)
                || type.equals(ObjectType.largeAnalogValue) || type.equals(ObjectType.characterstringValue);
    }

    private LocalDevice requireLocalDevice() {
        LocalDevice current = localDevice;
        if (!isConnected() || current == null) {
            throw new IllegalStateException("BACnet/IP 本地设备未启动");
        }
        return current;
    }

    private static Set<Integer> parseDeviceInstances(JSONObject config) {
        Object raw = config.get("deviceInstances");
        if (raw == null || raw.toString().isBlank()) {
            return Set.of();
        }
        if (!(raw instanceof String text)) {
            throw new IllegalArgumentException("deviceInstances 必须是逗号分隔字符串，例如 1001,1002");
        }
        Set<Integer> result = new HashSet<>();
        for (String value : text.split(",")) {
            if (value.isBlank()) {
                continue;
            }
            int instance;
            try {
                instance = Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("deviceInstances 包含非整数：" + value.trim(), e);
            }
            validateInstance(instance, "deviceInstances");
            result.add(instance);
        }
        return Set.copyOf(result);
    }

    private static NetworkBinding resolveNetworkBinding(String localIp) {
        if (localIp == null || localIp.isBlank()) {
            return automaticNetworkBinding();
        }
        try {
            InetAddress address = InetAddress.getByName(localIp.trim());
            if (!(address instanceof Inet4Address)) {
                throw new IllegalArgumentException("localIp 必须是 IPv4 地址");
            }
            NetworkInterface networkInterface = NetworkInterface.getByInetAddress(address);
            if (networkInterface == null) {
                throw new IllegalArgumentException("localIp 未绑定到本机网络接口：" + localIp);
            }
            for (InterfaceAddress interfaceAddress : networkInterface.getInterfaceAddresses()) {
                if (address.equals(interfaceAddress.getAddress()) && interfaceAddress.getBroadcast() != null) {
                    return new NetworkBinding(address.getHostAddress(),
                            interfaceAddress.getBroadcast().getHostAddress(),
                            interfaceAddress.getNetworkPrefixLength());
                }
            }
            throw new IllegalArgumentException("localIp 对应网卡没有可用的 IPv4 广播地址：" + localIp);
        } catch (Exception e) {
            if (e instanceof IllegalArgumentException illegalArgumentException) {
                throw illegalArgumentException;
            }
            throw new IllegalArgumentException("localIp 不是有效的本机 IPv4 地址：" + localIp, e);
        }
    }

    private static NetworkBinding automaticNetworkBinding() {
        try {
            NetworkBinding fallback = null;
            var interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces != null && interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();
                if (!networkInterface.isUp() || networkInterface.isLoopback() || networkInterface.isVirtual()) {
                    continue;
                }
                for (InterfaceAddress interfaceAddress : networkInterface.getInterfaceAddresses()) {
                    if (interfaceAddress.getAddress() instanceof Inet4Address address
                            && interfaceAddress.getBroadcast() != null) {
                        NetworkBinding candidate = new NetworkBinding(address.getHostAddress(),
                                interfaceAddress.getBroadcast().getHostAddress(),
                                interfaceAddress.getNetworkPrefixLength());
                        if (address.isSiteLocalAddress()) {
                            return candidate;
                        }
                        fallback = candidate;
                    }
                }
            }
            if (fallback != null) {
                return fallback;
            }
        } catch (Exception e) {
            log.warn("BACnet/IP 自动选择本机网卡失败，将使用全局广播：{}", rootMessage(e));
        }
        return new NetworkBinding("0.0.0.0", "255.255.255.255", 0);
    }

    private static int requiredInstance(JSONObject object, String key) {
        Integer value = nullableInteger(object, key);
        if (value == null) {
            throw new IllegalArgumentException(key + " 不能为空");
        }
        validateInstance(value, key);
        return value;
    }

    private static void validateInstance(int value, String name) {
        if (value < 0 || value >= ObjectIdentifier.UNINITIALIZED) {
            throw new IllegalArgumentException(name + " 必须在 0 到 4194302 之间");
        }
    }

    private static Integer nullableInteger(JSONObject object, String key) {
        if (object.containsKey(key) && object.get(key) != null && !object.get(key).toString().isBlank()) {
            return object.getInteger(key);
        }
        return null;
    }

    private static int positiveInt(JSONObject object, int fallback, String key) {
        Integer value = nullableInteger(object, key);
        if (value == null) {
            return fallback;
        }
        if (value <= 0) {
            throw new IllegalArgumentException(key + " 必须大于 0");
        }
        return value;
    }

    private record NetworkBinding(String bindAddress, String broadcastAddress, int prefixLength) {
    }

    private static String rootMessage(Throwable error) {
        Throwable current = error;
        while (current.getCause() != null) {
            current = current.getCause();
        }
        return current.getMessage() == null ? current.getClass().getSimpleName() : current.getMessage();
    }
}
