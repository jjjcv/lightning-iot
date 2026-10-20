package com.ruoyi.iot.listener;

import com.ruoyi.iot.cache.DeviceStateCache;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.event.DeviceBindingEvent;
import com.ruoyi.iot.event.DeviceHistoryEvent;
import com.ruoyi.iot.event.DeviceStateEvent;
import com.ruoyi.iot.scene.DeviceState;
import com.ruoyi.iot.scene.SceneEngine;
import com.ruoyi.iot.service.DeviceWebSocketManager;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationEventPublisher;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.isA;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class DeviceHistoryEventProducerTest {

    @Test
    void deviceStateListenerDoesNotPublishHistoryForDisabledProduct() {
        DeviceStateCache stateCache = mock(DeviceStateCache.class);
        SceneEngine sceneEngine = mock(SceneEngine.class);
        DeviceWebSocketManager webSocketManager = mock(DeviceWebSocketManager.class);
        ApplicationEventPublisher eventPublisher = mock(ApplicationEventPublisher.class);
        DeviceHistoryThrottle throttle = mock(DeviceHistoryThrottle.class);
        when(throttle.isProductEnabled("product-1")).thenReturn(false);

        DeviceStateListener listener = new DeviceStateListener(stateCache, sceneEngine,
            webSocketManager, eventPublisher, throttle);
        DataPoint point = DataPoint.builder().value("20").build();
        DeviceState state = new DeviceState("product-1", "device-1", Map.of("temperature", point));

        listener.onApplicationEvent(DeviceStateEvent.of(state));

        verify(throttle).isProductEnabled("product-1");
        verify(eventPublisher, never()).publishEvent(isA(DeviceHistoryEvent.class));
    }

    @Test
    void deviceBindingListenerDoesNotPublishHistoryForDisabledProduct() {
        IDeviceBindingService bindingService = mock(IDeviceBindingService.class);
        SceneEngine sceneEngine = mock(SceneEngine.class);
        IEdgeDataPointService edgeDataPointService = mock(IEdgeDataPointService.class);
        DeviceWebSocketManager webSocketManager = mock(DeviceWebSocketManager.class);
        ApplicationEventPublisher eventPublisher = mock(ApplicationEventPublisher.class);
        DeviceHistoryThrottle throttle = mock(DeviceHistoryThrottle.class);
        when(throttle.isProductEnabled("product-1")).thenReturn(false);

        DeviceBinding binding = new DeviceBinding();
        binding.setProductId("product-1");
        binding.setDeviceId("device-1");
        binding.setTelemetryKey("temperature");
        binding.setEdgePointId("point-1");
        when(bindingService.selectAllByGatewayId("gateway-1")).thenReturn(List.of(binding));

        DeviceBindingListener listener = new DeviceBindingListener(bindingService, sceneEngine,
            edgeDataPointService, webSocketManager, eventPublisher, throttle);
        DataPoint point = DataPoint.builder().id("point-1").value("20").build();
        Map<String, DataPoint> points = Map.of("point-1", point);

        listener.onApplicationEvent(DeviceBindingEvent.of(points, "gateway-1"));

        verify(throttle).isProductEnabled("product-1");
        verify(eventPublisher, never()).publishEvent(isA(DeviceHistoryEvent.class));
    }
}
