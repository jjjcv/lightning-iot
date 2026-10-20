package com.ruoyi.iot.cache;

import com.ruoyi.iot.domain.DeviceTelemetry;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SubscribeCacheTest {

    @Test
    void replacingRegistrationRemovesOldReverseIndex() {
        SubscribeCache cache = new SubscribeCache();
        DeviceTelemetry oldTelemetry = telemetry("product-1", "device-1", "temperature", "component-1");
        DeviceTelemetry newTelemetry = telemetry("product-1", "device-1", "humidity", "component-1");

        cache.put("ticket-1", Set.of(oldTelemetry));
        cache.put("ticket-1", Set.of(newTelemetry));

        assertNull(cache.getTickets("product-1:device-1:temperature"));
        assertTrue(cache.getTickets("product-1:device-1:humidity").contains("ticket-1"));
        assertFalse(cache.getTelemetryTags("ticket-1").contains(oldTelemetry));
    }

    @Test
    void emptyRegistrationClearsPreviousSubscription() {
        SubscribeCache cache = new SubscribeCache();
        DeviceTelemetry telemetry = telemetry("product-1", "device-1", "temperature", "component-1");

        cache.put("ticket-1", Set.of(telemetry));
        cache.put("ticket-1", Set.of());

        assertNull(cache.getTickets("product-1:device-1:temperature"));
        assertTrue(cache.getTelemetryTags("ticket-1").isEmpty());
    }

    private DeviceTelemetry telemetry(String productId, String deviceId, String telemetryKey, String componentId) {
        DeviceTelemetry telemetry = new DeviceTelemetry();
        telemetry.setProductId(productId);
        telemetry.setDeviceId(deviceId);
        telemetry.setTelemetryKey(telemetryKey);
        telemetry.setComponentId(componentId);
        return telemetry;
    }
}
