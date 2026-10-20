package com.ruoyi.iot.listener;

import com.ruoyi.iot.cache.DeviceStateCache;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.event.DeviceHistoryEvent;
import com.ruoyi.iot.event.DeviceStateEvent;
import com.ruoyi.iot.scene.DeviceState;
import com.ruoyi.iot.service.DeviceWebSocketManager;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 设备状态事件监听器
 * 监听设备直接上报的属性数据，负责保存设备状态、触发场景联动以及推送WebSocket通知
 */
@Component
public class DeviceStateListener implements ApplicationListener<DeviceStateEvent> {


    private final DeviceStateCache deviceStateCache;
    private final DeviceWebSocketManager webSocketManager;
    private final ApplicationEventPublisher eventPublisher;
    private final DeviceHistoryThrottle deviceHistoryThrottle;

    public DeviceStateListener(DeviceStateCache deviceStateCache,
                               DeviceWebSocketManager webSocketManager,
                               ApplicationEventPublisher eventPublisher,
                               DeviceHistoryThrottle deviceHistoryThrottle) {
        this.deviceStateCache = deviceStateCache;
        this.webSocketManager = webSocketManager;
        this.eventPublisher = eventPublisher;
        this.deviceHistoryThrottle = deviceHistoryThrottle;
    }


    /**
     * 处理设备状态事件
     * 当设备直接上报属性时触发，异步执行以下操作：
     * 1. 以DeviceState形式保存设备最新状态
     * 2. 触发场景联动
     * 3. 通过WebSocket直接推送设备状态
     *
     * @param event 设备状态事件，包含设备状态（产品ID、设备ID、属性集合）
     */
    @Async("virtualThreadExecutor")
    @Override
    public void onApplicationEvent(DeviceStateEvent event) {
        // 获取设备状态
        DeviceState deviceState = event.getDeviceState();

        // 以DeviceState形式保存设备最新状态
        deviceStateCache.put(deviceState);

        // 直接推送设备状态到WebSocket客户端
        webSocketManager.onDeviceState(deviceState);

        // 上报即组装历史事件，交由 DeviceHistoryListener 节流落库
        publishDeviceHistory(deviceState);
    }

    /**
     * 将设备上报的属性集合组装为 DeviceHistoryEvent 发布。
     * 只处理值非空的点位；createTime 用点位上报时间，缺失则用当前时间。
     */
    private void publishDeviceHistory(DeviceState deviceState) {
        String productId = deviceState.getProductId();
        if (!deviceHistoryThrottle.isProductEnabled(productId)) {
            return;
        }

        Map<String, DataPoint> properties = deviceState.getProperties();
        if (properties == null || properties.isEmpty()) {
            return;
        }
        String deviceId = deviceState.getDeviceId();
        List<DeviceHistory> list = new ArrayList<>(properties.size());
        for (Map.Entry<String, DataPoint> entry : properties.entrySet()) {
            DataPoint dataPoint = entry.getValue();
            if (dataPoint == null || dataPoint.getValue() == null) {
                continue;
            }
            DeviceHistory history = new DeviceHistory();
            history.setProductId(productId);
            history.setDeviceId(deviceId);
            history.setTelemetryKey(entry.getKey());
            history.setValue(String.valueOf(dataPoint.getValue()));
            history.setDataType(dataPoint.getType() == null ? null : dataPoint.getType().getType());
            history.setCreateTime(dataPoint.getLastTime() != null ? dataPoint.getLastTime() : new Date());
            list.add(history);
        }
        if (!list.isEmpty()) {
            eventPublisher.publishEvent(new DeviceHistoryEvent(list));
        }
    }


}
