package com.ruoyi.iot.plugin.knx;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import com.ruoyi.iot.metadata.Converter;
import io.calimero.DetachEvent;
import io.calimero.GroupAddress;
import io.calimero.KNXException;
import io.calimero.dptxlator.TranslatorTypes;
import io.calimero.knxnetip.KNXnetIPTunnel;
import io.calimero.link.KNXNetworkLinkIP;
import io.calimero.link.medium.TPSettings;
import io.calimero.process.ProcessCommunicatorImpl;
import io.calimero.process.ProcessEvent;
import io.calimero.process.ProcessListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * 基于 Calimero 3 的 KNXnet/IP 边缘适配器。
 *
 * <p>使用 KNXnet/IP tunneling 和 ProcessCommunicator 完成标准 DPT 读写，
 * 并监听 GroupValueWrite/GroupValueResponse 电报实时上报点位变化。</p>
 */
public class KnxEdgeAdapter extends EdgeAdapter {

    private static final Logger log = LoggerFactory.getLogger(KnxEdgeAdapter.class);
    private static final int RESPONSE_TIMEOUT_MILLIS = 6000;
    private static final int RECONNECT_INTERVAL_MILLIS = 10000;

    private final Object lifecycleLock = new Object();
    private final AtomicBoolean connected = new AtomicBoolean(false);
    private final ProcessListener processListener = new KnxProcessListener();

    private volatile KNXNetworkLinkIP link;
    private volatile ProcessCommunicatorImpl communicator;
    private volatile Disposable detectionDisposable;
    private volatile List<KnxPoint> points = List.of();
    private volatile Map<Integer, List<KnxPoint>> pointsByAddress = Map.of();

    private String ipAddress;
    private int port;

    @Override
    public void init(EdgeDeviceConfig edgeDevice) {
        JSONObject config = JSON.parseObject(edgeDevice.getConfiguration());
        if (config == null) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 KNX 配置");
        }

        ipAddress = trimToNull(firstString(config, "ipAddress", "ip_address"));
        if (ipAddress == null) {
            throw new IllegalArgumentException("KNX 网关必须配置 ipAddress");
        }
        port = requiredPort(config);
        try {
            parseIpv4Address(ipAddress);
        } catch (Exception e) {
            throw new IllegalArgumentException("KNX 网关 ipAddress 配置无效：" + rootMessage(e), e);
        }

        initializePoints();
        log.info("KNX 边缘网关 {} 初始化成功，endpoint:{}:{},points:{}",
                edgeDevice.getName(), ipAddress, port, points.size());
    }

    private void initializePoints() {
        List<KnxPoint> valid = new ArrayList<>();
        Map<Integer, List<KnxPoint>> byAddress = new HashMap<>();
        for (Map.Entry<String, DataPoint> entry : getDataPointMap().entrySet()) {
            try {
                KnxPoint point = parsePoint(entry.getValue());
                point.setId(entry.getKey());
                point.validateAndPrepare(entry.getValue().getName());
                TranslatorTypes.createTranslator(point.getDpt());
                valid.add(point);
                byAddress.computeIfAbsent(point.rawAddress(), ignored -> new ArrayList<>()).add(point);
            } catch (Exception e) {
                log.warn("KNX 边缘网关 {} 点位 {} 配置无效，已跳过：{}",
                        getEdgeDeviceName(), entry.getKey(), rootMessage(e));
            }
        }
        Map<Integer, List<KnxPoint>> immutableIndex = new HashMap<>();
        byAddress.forEach((address, addressPoints) ->
                immutableIndex.put(address, List.copyOf(addressPoints)));
        points = List.copyOf(valid);
        pointsByAddress = Map.copyOf(immutableIndex);
    }

    KnxPoint parsePoint(DataPoint dataPoint) {
        if (dataPoint.getConfig() == null || dataPoint.getConfig().isBlank()) {
            throw new IllegalArgumentException("点位配置为空");
        }
        JSONObject object = JSON.parseObject(dataPoint.getConfig());
        KnxPoint point = new KnxPoint();
        point.setGroupAddress(firstString(object,
                "groupAddress", "group_address", "address", "group_address_3_level"));
        point.setDpt(firstString(object, "dpt", "dptId", "dpt_id", "dataPointType"));
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
        } else {
            offline();
        }
        startDetectionLoop();
    }

    @Override
    public void disable() {
        setEnabledStatus(false);
        stopDetectionLoop();
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
            KNXNetworkLinkIP newLink = null;
            ProcessCommunicatorImpl newCommunicator = null;
            try {
                newLink = createTunnelingLink(new TPSettings());
                newCommunicator = new ProcessCommunicatorImpl(newLink);
                newCommunicator.responseTimeout(Duration.ofMillis(RESPONSE_TIMEOUT_MILLIS));
                newCommunicator.addProcessListener(processListener);
                link = newLink;
                communicator = newCommunicator;
                connected.set(true);
                log.info("KNX 边缘网关 {} 已连接：{}:{}", getEdgeDeviceName(), ipAddress, port);
                return true;
            } catch (Exception e) {
                log.error("KNX 边缘网关 {} 连接失败：{}", getEdgeDeviceName(), rootMessage(e), e);
                if (newCommunicator != null) {
                    newCommunicator.removeProcessListener(processListener);
                    newCommunicator.detach();
                }
                if (newLink != null) {
                    newLink.close();
                }
                connected.set(false);
                return false;
            }
        }
    }

    private KNXNetworkLinkIP createTunnelingLink(TPSettings settings) throws Exception {
        InetSocketAddress localEndpoint = new InetSocketAddress(0);
        InetSocketAddress remoteEndpoint = new InetSocketAddress(parseIpv4Address(ipAddress), port);
        return new ProcessTunnelingLink(localEndpoint, remoteEndpoint, settings);
    }

    /**
     * Creates the process-communication tunnel without Calimero's optional device-management probe.
     *
     * <p>The public UDP factory opens a second device-management connection to discover the medium
     * and maximum APDU length. Several otherwise valid KNX/IP gateways accept that connection but
     * never acknowledge the property reads, causing a 40-second delay and an ERROR-level
     * {@code KNXAckTimeoutException} on every reconnect. This adapter is fixed to TP1 and uses only
     * standard process datapoints, so the TP defaults are sufficient.</p>
     */
    private static final class ProcessTunnelingLink extends KNXNetworkLinkIP {
        private ProcessTunnelingLink(InetSocketAddress localEndpoint,
                                     InetSocketAddress remoteEndpoint,
                                     TPSettings settings) throws KNXException, InterruptedException {
            super(TunnelingV1,
                    new KNXnetIPTunnel(KNXnetIPTunnel.TunnelingLayer.LinkLayer,
                            localEndpoint, remoteEndpoint, false),
                    settings);
        }
    }

    @Override
    public boolean disconnect() {
        stopDataRefresh();
        synchronized (lifecycleLock) {
            closeConnectionQuietly();
        }
        offline();
        return true;
    }

    private void closeConnectionQuietly() {
        connected.set(false);
        ProcessCommunicatorImpl currentCommunicator = communicator;
        communicator = null;
        if (currentCommunicator != null) {
            currentCommunicator.removeProcessListener(processListener);
            currentCommunicator.detach();
        }
        KNXNetworkLinkIP currentLink = link;
        link = null;
        if (currentLink != null) {
            try {
                currentLink.close();
            } catch (Exception e) {
                log.warn("KNX 边缘网关 {} 关闭连接失败：{}", getEdgeDeviceName(), rootMessage(e));
            }
        }
    }

    @Override
    public boolean isConnected() {
        KNXNetworkLinkIP current = link;
        return connected.get() && current != null && current.isOpen();
    }

    @Override
    public DataPoint readDataPoint(DataPoint point) {
        ProcessCommunicatorImpl current = communicator;
        if (!isConnected() || current == null) {
            return point;
        }
        try {
            KnxPoint knxPoint = parsePoint(point);
            knxPoint.setId(point.getId());
            knxPoint.validateAndPrepare(point.getName());
            current.read(knxPoint.getDatapoint());
            DataPoint cached = getDataPointMap().get(point.getId());
            if (cached != null && cached != point) {
                copyValue(cached, point);
            }
        } catch (Exception e) {
            log.error("KNX 边缘网关 {} 读取点位 {} 失败：{}",
                    getEdgeDeviceName(), point.getId(), rootMessage(e), e);
        }
        return point;
    }

    private static void copyValue(DataPoint source, DataPoint target) {
        target.updateValue(source.getValue());
        target.setLastTime(source.getLastTime());
    }

    @Override
    public List<DataPoint> readDataPoints(List<DataPoint> requestedPoints) {
        List<DataPoint> result = new ArrayList<>(requestedPoints.size());
        for (DataPoint point : requestedPoints) {
            result.add(readDataPoint(point));
        }
        return result;
    }

    @Override
    public DataWriteResult writeDataPoint(String pointId, Object value) {
        DataPoint dataPoint = getDataPointMap().get(pointId);
        if (dataPoint == null) {
            return DataWriteResult.of(false, "下置点位缓存中不存在，请重启边缘网关设备");
        }
        ProcessCommunicatorImpl current = communicator;
        if (!isConnected() || current == null) {
            return DataWriteResult.of(false, "边缘网关未连接");
        }
        try {
            KnxPoint point = parsePoint(dataPoint);
            point.setId(pointId);
            point.validateAndPrepare(dataPoint.getName());
            Object converted = dataPoint.getType() instanceof Converter<?>
                    ? ((Converter<?>) dataPoint.getType()).convert(value)
                    : value;
            current.write(point.getParsedAddress(), KnxValueCodec.encode(point.getDpt(), converted));
            Object normalized = converted;
            try {
                normalized = KnxValueCodec.decode(
                        KnxValueCodec.encode(point.getDpt(), converted), dataPoint.getType());
            } catch (Exception ignored) {
                // Telegram was already written successfully; retaining the submitted value is safe here.
            }
            dataPoint.updateValue(normalized);
            dataPoint.setLastTime(new Date());
            return DataWriteResult.of(true, "点位下置成功");
        } catch (Exception e) {
            log.error("KNX 边缘网关 {} 点位 {} 下置失败：{}",
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

    /** KNX 采用总线事件推送，连接建立时监听器已附着，无需额外轮询任务。 */
    @Override
    public void startDataRefresh() {
        // Event-driven by ProcessListener.
    }

    @Override
    public void stopDataRefresh() {
        // Listener lifecycle follows ProcessCommunicator lifecycle.
    }

    @Override
    public void startDetectionLoop() {
        stopDetectionLoop();
        detectionDisposable = Flux.interval(Duration.ofMillis(RECONNECT_INTERVAL_MILLIS), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> Mono.fromRunnable(this::detectAndReconnect)
                        .subscribeOn(virtualThreadScheduler))
                .onErrorContinue((error, ignored) ->
                        log.error("KNX 边缘网关 {} 连接检测异常", getEdgeDeviceName(), error))
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

    private void handleProcessEvent(ProcessEvent event) {
        GroupAddress destination = event.getDestination();
        List<KnxPoint> matched = pointsByAddress.get(destination.getRawAddress());
        if (matched == null || matched.isEmpty()) {
            return;
        }
        Map<String, DataPoint> changed = new HashMap<>();
        for (KnxPoint point : matched) {
            DataPoint dataPoint = getDataPointMap().get(point.getId());
            if (dataPoint == null) {
                continue;
            }
            try {
                Object value = KnxValueCodec.decode(point.getDpt(), event.getASDU(), dataPoint.getType());
                Object previous = dataPoint.getValue();
                dataPoint.updateValue(value);
                dataPoint.setLastTime(new Date());
                if (!Objects.equals(previous, value)) {
                    changed.put(point.getId(), dataPoint.clone());
                }
            } catch (Exception e) {
                log.warn("KNX 边缘网关 {} 解析点位 {}({},{}) 电报失败：{}",
                        getEdgeDeviceName(), point.getId(), point.getGroupAddress(), point.getDpt(), rootMessage(e));
            }
        }
        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(getEdgeDeviceId(), changed);
        }
    }

    private final class KnxProcessListener implements ProcessListener {
        @Override
        public void groupReadRequest(ProcessEvent event) {
            // Edge client does not act as a group object server.
        }

        @Override
        public void groupReadResponse(ProcessEvent event) {
            handleProcessEvent(event);
        }

        @Override
        public void groupWrite(ProcessEvent event) {
            handleProcessEvent(event);
        }

        @Override
        public void detached(DetachEvent event) {
            connected.set(false);
            offline();
        }
    }

    private static int requiredPort(JSONObject config) {
        Integer value = config.getInteger("port");
        if (value == null) {
            throw new IllegalArgumentException("KNX 网关必须配置 port");
        }
        if (value < 1 || value > 65535) {
            throw new IllegalArgumentException("port 必须在 1 到 65535 之间");
        }
        return value;
    }

    private static String firstString(JSONObject object, String... keys) {
        for (String key : keys) {
            String value = object.getString(key);
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    private static String trimToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private static InetAddress parseIpv4Address(String value) throws Exception {
        String[] parts = value.split("\\.", -1);
        if (parts.length != 4) {
            throw new IllegalArgumentException("必须是 IPv4 地址");
        }
        byte[] address = new byte[4];
        for (int i = 0; i < parts.length; i++) {
            if (parts[i].isEmpty() || (parts[i].length() > 1 && parts[i].startsWith("0"))) {
                throw new IllegalArgumentException("必须是规范 IPv4 地址");
            }
            int octet;
            try {
                octet = Integer.parseInt(parts[i]);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("必须是 IPv4 地址", e);
            }
            if (octet < 0 || octet > 255) {
                throw new IllegalArgumentException("IPv4 地址段必须在 0 到 255 之间");
            }
            address[i] = (byte) octet;
        }
        return InetAddress.getByAddress(address);
    }

    private static String rootMessage(Throwable error) {
        Throwable current = error;
        while (current.getCause() != null) {
            current = current.getCause();
        }
        return current.getMessage() == null ? current.getClass().getSimpleName() : current.getMessage();
    }
}
