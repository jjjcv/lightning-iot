package com.ruoyi.iot.scene;

import com.ruoyi.iot.edge.DataPoint;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/** Latest device state used by telemetry, WebSocket, and history services. */
@Data
public class DeviceState {
    private final String deviceId;
    private final String productId;
    private final Map<String, DataPoint> properties = new ConcurrentHashMap<>();
    private LocalDateTime lastUpdateTime;

    public DeviceState(String productId, String deviceId) {
        this.deviceId = deviceId;
        this.productId = productId;
        this.lastUpdateTime = LocalDateTime.now();
    }

    public DeviceState(String productId, String deviceId, Map<String, DataPoint> properties) {
        this(productId, deviceId);
        this.properties.putAll(properties);
    }

    public DeviceState(String productId, String deviceId, Map<String, DataPoint> properties, LocalDateTime lastUpdateTime) {
        this.deviceId = deviceId;
        this.productId = productId;
        this.properties.putAll(properties);
        this.lastUpdateTime = lastUpdateTime;
    }

    public boolean updateProperties(Map<String, DataPoint> newProperties) {
        boolean changed = newProperties.entrySet().stream()
            .anyMatch(entry -> !entry.getValue().equals(properties.get(entry.getKey())));
        if (changed) {
            properties.putAll(newProperties);
            lastUpdateTime = LocalDateTime.now();
        }
        return changed;
    }

    public DataPoint getProperty(String propertyName) { return properties.get(propertyName); }
    public Map<String, DataPoint> getProperties() { return new HashMap<>(properties); }
}
