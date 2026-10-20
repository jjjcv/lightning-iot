package com.ruoyi.iot.plugin.plc4x;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import com.ruoyi.iot.metadata.Converter;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.PlcDriverManager;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.messages.PlcSubscriptionEvent;
import org.apache.plc4x.java.api.messages.PlcSubscriptionRequest;
import org.apache.plc4x.java.api.messages.PlcSubscriptionResponse;
import org.apache.plc4x.java.api.messages.PlcUnsubscriptionRequest;
import org.apache.plc4x.java.api.messages.PlcWriteRequest;
import org.apache.plc4x.java.api.messages.PlcWriteResponse;
import org.apache.plc4x.java.api.model.PlcSubscriptionHandle;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * PLC4X 边缘适配器。
 *
 * <p>负责将平台点位配置转换为 PLC4X tag 读写请求，并在设备在线后优先使用订阅刷新点位数据；
 * 当驱动或点位不支持订阅时，按配置回退到周期轮询。</p>
 */
public class Plc4xEdgeAdapter extends EdgeAdapter {

    private static final Logger log = LoggerFactory.getLogger(Plc4xEdgeAdapter.class);

    /**
     * PLC4X 的连接对象不是线程安全边界，读、写、订阅和重连需要串行化。
     */
    private final Object connectionLock = new Object();

    /** 重连检测任务。 */
    private volatile Disposable connectDisposable;

    /** 周期轮询刷新任务，仅在订阅不可用或回退轮询时启用。 */
    private volatile Disposable pollingDisposable;

    /** 当前 PLC4X 连接，重连时整体替换。 */
    private volatile PlcConnection plcConnection;

    /** 从平台点位配置解析出的有效 PLC4X 点位快照。 */
    private volatile List<Plc4xPoint> points = List.of();

    /** 当前已经建立的订阅句柄，用于停止刷新或断线时取消订阅。 */
    private volatile List<PlcSubscriptionHandle> subscriptionHandles = List.of();

    /** PLC4X connection string，例如 modbus、s7、opcua 等驱动地址。 */
    private String connectionString;

    /** 单次 PLC4X 请求超时时间，单位毫秒。 */
    private int requestTimeout = 5000;

    /** 轮询刷新间隔，单位毫秒；也作为 cyclic 订阅的默认周期。 */
    private int refreshInterval = 1000;

    /** 断线检测和重连间隔，单位毫秒。 */
    private int connectInterval = 30000;

    /** 是否优先尝试 PLC4X 订阅模式。 */
    private boolean preferSubscription = true;

    /** 订阅建立失败或部分失败时是否回退到轮询模式。 */
    private boolean fallbackToPolling = true;

    @Override
    public void enable() {
        if (isEnabled()) {
            return;
        }

        setEnabledStatus(true);
        // 启用时先尝试建立连接，连接成功后立即启动数据刷新，避免等待下一次检测周期。
        if (connect()) {
            startDataRefresh();
            online();
        } else {
            offline();
        }
        // 检测循环负责后续断线重连。
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
    public void init(EdgeDeviceConfig edgeDevice) {
        // 设备扩展配置负责控制连接地址、超时、刷新策略等 PLC4X 运行参数。
        JSONObject config = JSON.parseObject(edgeDevice.getConfiguration());
        if (config == null) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 PLC4X 配置");
        }

        this.connectionString = config.getString("connection_string");
        Integer requestTimeout = config.getInteger("request_timeout");
        this.requestTimeout = requestTimeout != null && requestTimeout > 0 ? requestTimeout : 5000;
        Integer refreshInterval = config.getInteger("refresh_interval");
        this.refreshInterval = refreshInterval != null && refreshInterval > 0 ? refreshInterval : 1000;
        Integer connectInterval = config.getInteger("connect_interval");
        this.connectInterval = connectInterval != null && connectInterval > 0 ? connectInterval : 30000;
        Boolean preferSubscription = config.getBoolean("prefer_subscription");
        this.preferSubscription = preferSubscription == null || preferSubscription;
        Boolean fallbackToPolling = config.getBoolean("fallback_to_polling");
        this.fallbackToPolling = fallbackToPolling == null || fallbackToPolling;

        if (this.connectionString == null || this.connectionString.isBlank()) {
            throw new IllegalArgumentException("边缘网关 " + edgeDevice.getName() + " 缺少 connection_string 配置");
        }

        initializePoints();
        log.info("PLC4X 边缘网关 {} 初始化成功，connectionString:{},requestTimeout:{},refreshInterval:{},preferSubscription:{}",
                getEdgeDeviceName(), this.connectionString, this.requestTimeout, this.refreshInterval, this.preferSubscription);
    }

    /**
     * 初始化可读写的 PLC4X 点位快照。
     *
     * <p>非法点位只记录告警并跳过，避免单个点位配置错误导致整个边缘网关不可用。</p>
     */
    private void initializePoints() {
        List<Plc4xPoint> valid = new ArrayList<>();
        for (Map.Entry<String, DataPoint> entry : getDataPointMap().entrySet()) {
            try {
                Plc4xPoint point = parsePoint(entry.getValue());
                point.setId(entry.getKey());
                if (point.getTagAddress() == null || point.getTagAddress().isBlank()) {
                    log.warn("PLC4X 边缘网关 {} 点位 {} 缺少 tag_address，已跳过", getEdgeDeviceName(), entry.getKey());
                    continue;
                }
                valid.add(point);
            } catch (Exception e) {
                log.warn("PLC4X 边缘网关 {} 点位 {} 配置无效，已跳过：{}", getEdgeDeviceName(), entry.getKey(), e.getMessage());
            }
        }
        this.points = valid;
    }

    /**
     * 将平台点位配置解析为 PLC4X 点位配置。
     *
     * <p>兼容历史配置中的 address 字段，新配置优先使用 tag_address。</p>
     */
    private Plc4xPoint parsePoint(DataPoint dataPoint) {
        String config = dataPoint.getConfig();
        if (config == null || config.isBlank()) {
            throw new IllegalArgumentException("点位配置为空");
        }
        Plc4xPoint point = JSON.parseObject(config, Plc4xPoint.class);
        if (point.getTagAddress() == null || point.getTagAddress().isBlank()) {
            JSONObject object = JSON.parseObject(config);
            String address = object.getString("address");
            if (address != null && !address.isBlank()) {
                point.setTagAddress(address);
            }
        }
        return point;
    }

    @Override
    public boolean connect() {
        synchronized (connectionLock) {
            // 每次重连前先关闭旧连接，避免驱动底层资源和订阅句柄残留。
            disconnectQuietly();
            try {
                PlcConnection connection = PlcDriverManager.getDefault()
                        .getConnectionManager()
                        .getConnection(this.connectionString);
                this.plcConnection = connection;
                return connection.isConnected();
            } catch (Exception e) {
                log.error("PLC4X 边缘网关 {} 连接失败：{}", getEdgeDeviceName(), this.connectionString, e);
                disconnectQuietly();
                return false;
            }
        }
    }

    @Override
    public boolean isConnected() {
        PlcConnection connection = this.plcConnection;
        return connection != null && connection.isConnected();
    }

    @Override
    public boolean disconnect() {
        // 先停止刷新任务，再关闭连接，避免任务继续使用已关闭的连接对象。
        stopDataRefresh();
        synchronized (connectionLock) {
            disconnectQuietly();
        }
        offline();
        return true;
    }

    private void disconnectQuietly() {
        PlcConnection connection = this.plcConnection;
        if (connection != null) {
            try {
                connection.close();
            } catch (Exception e) {
                log.warn("PLC4X 边缘网关 {} 关闭连接失败", getEdgeDeviceName(), e);
            }
            this.plcConnection = null;
            this.subscriptionHandles = List.of();
        }
    }

    @Override
    public DataPoint readDataPoint(DataPoint point) {
        try {
            Plc4xPoint plc4xPoint = parsePoint(point);
            plc4xPoint.setId(point.getId());
            Object value = readPointValue(plc4xPoint);
            if (value != null) {
                // 同步更新入参点位和适配器缓存，保证主动读取与后续变更发布看到同一份值。
                point.updateValue(value);
                point.setLastTime(new Date());
                DataPoint cached = getDataPointMap().get(point.getId());
                if (cached != null) {
                    cached.updateValue(value);
                    cached.setLastTime(new Date());
                }
            }
        } catch (Exception e) {
            log.error("PLC4X 边缘网关 {} 读取点位 {} 失败", getEdgeDeviceName(), point.getId(), e);
        }
        return point;
    }

    @Override
    public List<DataPoint> readDataPoints(List<DataPoint> points) {
        List<DataPoint> results = new ArrayList<>(points.size());
        for (DataPoint point : points) {
            results.add(readDataPoint(point));
        }
        return results;
    }

    @Override
    public DataWriteResult writeDataPoint(String pointId, Object value) {
        DataPoint dataPoint = getDataPointMap().get(pointId);
        if (dataPoint == null) {
            return DataWriteResult.of(false, "下置点位缓存中不存在，请重启边缘网关设备");
        }
        PlcConnection connection = this.plcConnection;
        if (connection == null || !connection.isConnected()) {
            return DataWriteResult.of(false, "边缘网关未连接");
        }
        if (!connection.getMetadata().isWriteSupported()) {
            return DataWriteResult.of(false, "当前 PLC4X 连接不支持写入");
        }

        try {
            Plc4xPoint point = parsePoint(dataPoint);
            // 写入前按点位类型转换，避免 PLC 驱动接收到平台侧的原始字符串或对象类型。
            Object converted = dataPoint.getType() instanceof Converter<?>
                    ? ((Converter<?>) dataPoint.getType()).convert(value)
                    : value;
            synchronized (connectionLock) {
                PlcWriteRequest writeRequest = connection.writeRequestBuilder()
                        .addTagAddress(pointId, point.getTagAddress(), converted)
                        .build();
                PlcWriteResponse response = writeRequest.execute().get(requestTimeout, TimeUnit.MILLISECONDS);
                PlcResponseCode responseCode = response.getResponseCode(pointId);
                if (responseCode == PlcResponseCode.OK) {
                    dataPoint.updateValue(converted);
                    dataPoint.setLastTime(new Date());
                    return DataWriteResult.of(true, "点位下置成功");
                }
                return DataWriteResult.of(false, "点位下置失败：" + responseCode.name());
            }
        } catch (Exception e) {
            log.error("PLC4X 边缘网关 {} 点位 {} 下置失败", getEdgeDeviceName(), pointId, e);
            return DataWriteResult.of(false, "点位下置失败");
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
        PlcConnection connection = this.plcConnection;
        // 支持订阅的驱动优先订阅，减少轮询带来的 PLC 和网络压力。
        if (preferSubscription && connection != null && connection.isConnected()
                && connection.getMetadata().isSubscribeSupported()) {
            if (startSubscription(connection)) {
                return;
            }
            if (!fallbackToPolling) {
                return;
            }
        }

        startPollingRefresh();
    }

    /**
     * 启动轮询刷新。
     *
     * <p>使用 concatMap 保证每一轮批量读取按顺序执行，不会在 PLC 请求超时时堆叠并发读。</p>
     */
    private void startPollingRefresh() {
        if (pollingDisposable != null && !pollingDisposable.isDisposed()) {
            return;
        }

        this.pollingDisposable = Flux.interval(Duration.ofMillis(this.refreshInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> readAllDataPoints())
                .doOnError(error -> {
                    log.error("PLC4X 边缘网关 {} 轮询刷新异常", getEdgeDeviceName(), error);
                    disconnect();
                })
                .onErrorComplete()
                .subscribe();
    }

    /**
     * 为当前有效点位建立订阅。
     *
     * @return 所有可用订阅已建立时返回 true；需要回退轮询时返回 false。
     */
    private boolean startSubscription(PlcConnection connection) {
        if (!subscriptionHandles.isEmpty()) {
            return true;
        }
        List<Plc4xPoint> snapshot = this.points;
        if (snapshot == null || snapshot.isEmpty()) {
            return true;
        }

        try {
            PlcSubscriptionRequest.Builder builder = connection.subscriptionRequestBuilder();
            for (Plc4xPoint point : snapshot) {
                addSubscriptionTag(builder, point);
            }
            PlcSubscriptionRequest request = builder.build();
            PlcSubscriptionResponse response = request.execute().get(requestTimeout, TimeUnit.MILLISECONDS);
            List<PlcSubscriptionHandle> handles = new ArrayList<>();
            for (Plc4xPoint point : snapshot) {
                PlcResponseCode responseCode = response.getResponseCode(point.getId());
                if (responseCode == PlcResponseCode.OK) {
                    handles.add(response.getSubscriptionHandle(point.getId()));
                } else {
                    log.warn("PLC4X 边缘网关 {} 点位 {} 订阅失败：{}", getEdgeDeviceName(), point.getId(), responseCode);
                }
            }
            this.subscriptionHandles = handles;
            // 只要存在点位订阅失败，轮询回退能保证所有点位仍然有刷新路径。
            if (handles.size() < snapshot.size() && fallbackToPolling) {
                log.warn("PLC4X 边缘网关 {} 仅成功建立 {}/{} 个订阅，回退到轮询读取",
                        getEdgeDeviceName(), handles.size(), snapshot.size());
                unsubscribeQuietly();
                return false;
            }
            log.info("PLC4X 边缘网关 {} 已建立 {} 个订阅", getEdgeDeviceName(), handles.size());
            return !handles.isEmpty();
        } catch (Exception e) {
            log.error("PLC4X 边缘网关 {} 建立订阅失败", getEdgeDeviceName(), e);
            this.subscriptionHandles = List.of();
            return false;
        }
    }

    /**
     * 按点位配置注册订阅类型。
     *
     * <p>默认 cyclic 订阅最接近轮询语义；change/event 依赖具体驱动支持。</p>
     */
    private void addSubscriptionTag(PlcSubscriptionRequest.Builder builder, Plc4xPoint point) {
        String type = point.getSubscriptionType();
        String normalized = type == null || type.isBlank() ? "cyclic" : type.trim().toLowerCase();
        switch (normalized) {
            case "change", "change_of_state" ->
                    builder.addChangeOfStateTagAddress(point.getId(), point.getTagAddress(), this::handleSubscriptionEvent);
            case "event" ->
                    builder.addEventTagAddress(point.getId(), point.getTagAddress(), this::handleSubscriptionEvent);
            default -> {
                int interval = point.getSubscriptionInterval() != null && point.getSubscriptionInterval() > 0
                        ? point.getSubscriptionInterval()
                        : this.refreshInterval;
                builder.addCyclicTagAddress(point.getId(), point.getTagAddress(), Duration.ofMillis(interval), this::handleSubscriptionEvent);
            }
        }
    }

    /**
     * 处理 PLC4X 推送的订阅事件，并仅发布值发生变化的点位。
     */
    private void handleSubscriptionEvent(PlcSubscriptionEvent event) {
        Map<String, DataPoint> changed = new HashMap<>();
        for (String tagName : event.getTagNames()) {
            PlcResponseCode responseCode = event.getResponseCode(tagName);
            if (responseCode != PlcResponseCode.OK) {
                log.warn("PLC4X 边缘网关 {} 订阅点位 {} 事件异常：{}", getEdgeDeviceName(), tagName, responseCode);
                continue;
            }
            DataPoint dataPoint = getDataPointMap().get(tagName);
            if (dataPoint == null) {
                continue;
            }
            Object value = extractValue(event, tagName);
            dataPoint.updateValue(value);
            dataPoint.setLastTime(Date.from(event.getTimestamp()));
            // clone 会保留 updateValue 之前的 oldValue，用于判断是否需要发布变化事件。
            DataPoint clone = dataPoint.clone();
            if (clone.getValue() != null && !Objects.equals(clone.getValue(), clone.getOldValue())) {
                changed.put(clone.getId(), clone);
            }
        }
        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(getEdgeDeviceId(), changed);
        }
    }

    @Override
    public void stopDataRefresh() {
        Disposable disposable = this.pollingDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
        this.pollingDisposable = null;
        unsubscribeQuietly();
    }

    /**
     * 取消当前全部订阅。
     *
     * <p>取消失败不向外抛出，连接关闭或重连流程仍需继续完成。</p>
     */
    private void unsubscribeQuietly() {
        List<PlcSubscriptionHandle> handles = this.subscriptionHandles;
        if (handles == null || handles.isEmpty()) {
            return;
        }
        PlcConnection connection = this.plcConnection;
        try {
            if (connection != null && connection.isConnected()) {
                PlcUnsubscriptionRequest request = connection.unsubscriptionRequestBuilder()
                        .addHandles(handles)
                        .build();
                request.execute().get(requestTimeout, TimeUnit.MILLISECONDS);
            }
        } catch (Exception e) {
            log.warn("PLC4X 边缘网关 {} 取消订阅失败", getEdgeDeviceName(), e);
        } finally {
            this.subscriptionHandles = List.of();
        }
    }

    @Override
    public void startDetectionLoop() {
        this.connectDisposable = Flux.interval(Duration.ofMillis(this.connectInterval), edgeScheduler)
                .onBackpressureLatest()
                .concatMap(tick -> {
                    try {
                        if (isConnected()) {
                            return Mono.empty();
                        }
                        // 检测到断线后重建连接和刷新任务，连接失败则维持离线状态等待下一轮。
                        if (connect()) {
                            startDataRefresh();
                            online();
                        } else {
                            offline();
                        }
                    } catch (Exception e) {
                        log.error("PLC4X 边缘网关 {} 检测循环异常", getEdgeDeviceName(), e);
                    }
                    return Mono.empty();
                })
                .subscribe();
    }

    @Override
    public void stopDetectionLoop() {
        Disposable disposable = this.connectDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }

    /**
     * 读取一次全部点位，并在读取成功后发布发生变化的点位。
     */
    private Mono<Void> readAllDataPoints() {
        List<Plc4xPoint> snapshot = this.points;
        if (snapshot == null || snapshot.isEmpty()) {
            return Mono.empty();
        }

        // PLC I/O 放到虚拟线程调度器，避免阻塞边缘任务调度线程。
        return Mono.fromRunnable(() -> readPointBatch(snapshot))
                .subscribeOn(virtualThreadScheduler)
                .timeout(Duration.ofMillis(requestTimeout + 1000L))
                .retryWhen(Retry.backoff(1, Duration.ofMillis(200)).maxBackoff(Duration.ofSeconds(1)))
                .then(Mono.fromRunnable(this::publishChangedDataPoints));
    }

    /**
     * 批量读取点位值。
     *
     * <p>同一连接上的批量读需要与写入、重连互斥，避免请求和连接关闭交叉执行。</p>
     */
    private void readPointBatch(List<Plc4xPoint> snapshot) {
        PlcConnection connection = this.plcConnection;
        if (connection == null || !connection.isConnected()) {
            throw new IllegalStateException("PLC4X connection is not connected");
        }
        if (!connection.getMetadata().isReadSupported()) {
            throw new IllegalStateException("PLC4X connection does not support read");
        }

        synchronized (connectionLock) {
            try {
                // 使用点位 ID 作为 tagName，便于响应结果直接回写到平台点位缓存。
                PlcReadRequest.Builder builder = connection.readRequestBuilder();
                for (Plc4xPoint point : snapshot) {
                    builder.addTagAddress(point.getId(), point.getTagAddress());
                }
                PlcReadResponse response = builder.build().execute().get(requestTimeout, TimeUnit.MILLISECONDS);
                for (Plc4xPoint point : snapshot) {
                    updateDataPoint(point, response);
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }

    /**
     * 主动读取单个点位值，用于外部按需读取接口。
     */
    private Object readPointValue(Plc4xPoint point) throws Exception {
        PlcConnection connection = this.plcConnection;
        if (connection == null || !connection.isConnected()) {
            return null;
        }
        if (!connection.getMetadata().isReadSupported()) {
            return null;
        }

        synchronized (connectionLock) {
            PlcReadRequest readRequest = connection.readRequestBuilder()
                    .addTagAddress(point.getId(), point.getTagAddress())
                    .build();
            PlcReadResponse response = readRequest.execute().get(requestTimeout, TimeUnit.MILLISECONDS);
            if (response.getResponseCode(point.getId()) != PlcResponseCode.OK) {
                return null;
            }
            return extractValue(response, point.getId());
        }
    }

    /**
     * 将单个 PLC4X 响应项回写到平台点位缓存。
     */
    private void updateDataPoint(Plc4xPoint point, PlcReadResponse response) {
        PlcResponseCode responseCode = response.getResponseCode(point.getId());
        if (responseCode != PlcResponseCode.OK) {
            log.warn("PLC4X 边缘网关 {} 点位 {} 读取失败：{}", getEdgeDeviceName(), point.getId(), responseCode);
            return;
        }

        Object value = extractValue(response, point.getId());
        DataPoint dataPoint = getDataPointMap().get(point.getId());
        if (dataPoint != null) {
            dataPoint.updateValue(value);
            dataPoint.setLastTime(new Date());
        }
    }

    /**
     * 提取 PLC4X 响应值。
     *
     * <p>单值点位返回标量，多值点位返回 List，保留 PLC4X 驱动返回的原始对象类型。</p>
     */
    private Object extractValue(PlcReadResponse response, String tagName) {
        int numberOfValues = response.getNumberOfValues(tagName);
        if (numberOfValues <= 1) {
            return response.getObject(tagName);
        }
        List<Object> values = new ArrayList<>(numberOfValues);
        for (int i = 0; i < numberOfValues; i++) {
            values.add(response.getObject(tagName, i));
        }
        return values;
    }

    /**
     * 扫描平台点位缓存并发布值发生变化的点位。
     */
    private void publishChangedDataPoints() {
        Map<String, DataPoint> changed = new HashMap<>();
        for (DataPoint dataPoint : getDataPointMap().values()) {
            DataPoint clone = dataPoint.clone();
            if (clone.getValue() == null || Objects.equals(clone.getValue(), clone.getOldValue())) {
                continue;
            }
            changed.put(clone.getId(), clone);
        }

        if (!changed.isEmpty() && getRuntimeContext() != null) {
            getRuntimeContext().publishDataPoints(getEdgeDeviceId(), changed);
        }
    }
}
