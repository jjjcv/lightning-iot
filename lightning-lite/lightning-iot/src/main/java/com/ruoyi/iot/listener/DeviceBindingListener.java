package com.ruoyi.iot.listener;

import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.event.DeviceBindingEvent;
import com.ruoyi.iot.event.DeviceHistoryEvent;
import com.ruoyi.iot.service.DeviceWebSocketManager;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 设备绑定事件监听器
 * 监听设备数据点更新事件，负责更新绑定关系、触发场景联动以及推送WebSocket通知
 */
@Component
public class DeviceBindingListener implements ApplicationListener<DeviceBindingEvent> {


    private final IDeviceBindingService deviceBindingService;
    private final IEdgeDataPointService edgeDataPointService;
    private final DeviceWebSocketManager webSocketManager;
    private final ApplicationEventPublisher eventPublisher;
    private final DeviceHistoryThrottle deviceHistoryThrottle;

    public DeviceBindingListener(IDeviceBindingService deviceBindingService,
                                 IEdgeDataPointService edgeDataPointService,
                                 DeviceWebSocketManager webSocketManager,
                                 ApplicationEventPublisher eventPublisher,
                                 DeviceHistoryThrottle deviceHistoryThrottle) {
        this.deviceBindingService = deviceBindingService;
        this.edgeDataPointService = edgeDataPointService;
        this.webSocketManager = webSocketManager;
        this.eventPublisher = eventPublisher;
        this.deviceHistoryThrottle = deviceHistoryThrottle;
    }


    /**
     * 处理设备绑定事件
     * 当网关设备上报数据点时触发，异步执行以下操作：
     * 1. 批量更新Redis中的数据点值
     * 2. 查询该网关下的所有设备绑定关系
     * 3. 更新绑定的设备值并触发场景联动
     * 4. 通过WebSocket推送属性变更通知
     *
     * @param event 设备绑定事件，包含网关ID和数据点集合
     */
    @Async("virtualThreadExecutor")
    @Override
    public void onApplicationEvent(DeviceBindingEvent event) {
        // 获取网关设备ID
        String edgeDeviceId = event.getEdgeDeviceId();
        // 获取事件源中的数据点集合（key为点位ID，value为数据点对象）
        Map<String, DataPoint> dataPointMap = (Map<String, DataPoint>) event.getSource();

        // 批量更新Redis中的数据点值
        edgeDataPointService.updateValueRedisBatchById(new ArrayList<>(dataPointMap.values()));

        // 查询该网关下的所有设备绑定关系
        List<DeviceBinding> deviceBindings = deviceBindingService.selectAllByGatewayId(edgeDeviceId);
        // 记录实际更新的绑定关系，用于后续WebSocket推送
        List<DeviceBinding> updatedBindings = new ArrayList<>();
        // 组装历史记录，交由 DeviceHistoryListener 节流落库
        List<DeviceHistory> historyList = new ArrayList<>();
        // 同一批绑定通常属于少量产品，避免为每个点位重复检查产品状态。
        Map<String, Boolean> historyEnabledByProduct = new HashMap<>();

        // 遍历每个设备绑定关系，更新对应的数据点值
        for (DeviceBinding binding : deviceBindings) {
            // 获取绑定的边缘点位ID
            String pointId = binding.getEdgePointId();
            // 从数据点集合中查找对应的数据点
            DataPoint dataPoint = dataPointMap.get(pointId);

            // 只有当数据点存在且值不为空时才进行更新
            if (dataPoint != null) {
                if (dataPoint.getValue() == null){
                    continue;
                }

                // 更新绑定对象的值和时间
                binding.setValue(String.valueOf(dataPoint.getValue()));
                binding.setLastTime(dataPoint.getLastTime());

                // 将更新后的绑定值存入缓存/数据库
                deviceBindingService.putValue(binding);
                // 添加到已更新列表
                updatedBindings.add(binding);

                // Product 停用时不组装历史记录，也不发布对应的历史事件。
                String productId = binding.getProductId();
                boolean historyEnabled = historyEnabledByProduct.computeIfAbsent(productId,
                    deviceHistoryThrottle::isProductEnabled);
                if (historyEnabled) {
                    DeviceHistory history = new DeviceHistory();
                    history.setProductId(productId);
                    history.setDeviceId(binding.getDeviceId());
                    history.setTelemetryKey(binding.getTelemetryKey());
                    history.setDataType(binding.getDataType());
                    history.setValue(binding.getValue());
                    history.setCreateTime(binding.getLastTime() != null ? binding.getLastTime() : new Date());
                    historyList.add(history);
                }

            }
        }

        // 批量推送属性变更通知到WebSocket客户端
        webSocketManager.onPropertyChangeList(updatedBindings);

        // 发布历史事件
        if (!historyList.isEmpty()) {
            eventPublisher.publishEvent(new DeviceHistoryEvent(historyList));
        }
    }


}
