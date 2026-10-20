package com.ruoyi.iot.plugin.bacnet;

import com.ruoyi.iot.edge.EdgeDeviceConfig;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

class BacnetEdgeAdapterConfigTest {

    @Test
    void acceptsMinimalConnectionConfiguration() {
        assertDoesNotThrow(() -> new BacnetEdgeAdapter().init(config("""
                {"localDeviceInstance":390001,"deviceInstances":"1001,1002","pollingInterval":3000}
                """)));
    }

    @Test
    void requiresLocalDeviceInstance() {
        assertThrows(IllegalArgumentException.class,
                () -> new BacnetEdgeAdapter().init(config("{}")));
    }

    @Test
    void doesNotAcceptRemovedLocalDeviceAliases() {
        assertThrows(IllegalArgumentException.class,
                () -> new BacnetEdgeAdapter().init(config("""
                        {"localDeviceId":390001}
                        """)));
    }

    @Test
    void deviceInstancesMustBeCommaSeparatedString() {
        assertThrows(IllegalArgumentException.class,
                () -> new BacnetEdgeAdapter().init(config("""
                        {"localDeviceInstance":390001,"deviceInstances":[1001,1002]}
                        """)));
    }

    private static EdgeDeviceConfig config(String configuration) {
        return new EdgeDeviceConfig() {
            @Override public String getId() { return "gateway-1"; }
            @Override public String getName() { return "BACnet 测试网关"; }
            @Override public String getProtocolId() { return "bacnet"; }
            @Override public String getConfiguration() { return configuration; }
        };
    }
}
