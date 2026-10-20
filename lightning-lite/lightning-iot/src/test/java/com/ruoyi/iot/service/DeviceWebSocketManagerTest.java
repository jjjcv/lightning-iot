package com.ruoyi.iot.service;

import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceTelemetry;
import com.ruoyi.iot.edge.DataPoint;
import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class DeviceWebSocketManagerTest {

    @Test
    void directDeviceStateUsesTheSamePayloadShapeAsBindingUpdates() {
        DeviceTelemetry telemetry = new DeviceTelemetry();
        telemetry.setProductId("product-1");
        telemetry.setDeviceId("device-1");
        telemetry.setTelemetryKey("temperature");
        Date lastTime = new Date();
        DataPoint point = DataPoint.builder().value(21.5).lastTime(lastTime).build();

        DeviceBinding result = DeviceWebSocketManager.toDeviceBinding(telemetry, point);

        assertEquals("product-1", result.getProductId());
        assertEquals("device-1", result.getDeviceId());
        assertEquals("temperature", result.getTelemetryKey());
        assertEquals("21.5", result.getValue());
        assertEquals(lastTime, result.getLastTime());
        assertNull(result.getDataType());
    }
}
