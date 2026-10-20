package com.ruoyi.iot.plugin.knx;

import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.edge.EdgeDeviceConfig;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class KnxEdgeAdapterConfigTest {

    @Test
    void acceptsRequiredIpAddressAndPort() {
        KnxEdgeAdapter adapter = new KnxEdgeAdapter();

        assertDoesNotThrow(() -> adapter.init(config(
                "{\"ipAddress\":\"192.168.1.20\",\"port\":3671}")));
    }

    @Test
    void rejectsMissingIpAddress() {
        KnxEdgeAdapter adapter = new KnxEdgeAdapter();

        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> adapter.init(config("{\"port\":3671}")));
        assertEquals("KNX 网关必须配置 ipAddress", error.getMessage());
    }

    @Test
    void rejectsMissingPort() {
        KnxEdgeAdapter adapter = new KnxEdgeAdapter();

        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> adapter.init(config("{\"ipAddress\":\"192.168.1.20\"}")));
        assertEquals("KNX 网关必须配置 port", error.getMessage());
    }

    @Test
    void rejectsHostNameInsteadOfIpv4Address() {
        KnxEdgeAdapter adapter = new KnxEdgeAdapter();

        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> adapter.init(config("{\"ipAddress\":\"knx.local\",\"port\":3671}")));
        assertEquals("KNX 网关 ipAddress 配置无效：必须是 IPv4 地址", error.getMessage());
    }

    @Test
    void parsesCanonicalAndLegacyPointPropertyNames() throws Exception {
        KnxEdgeAdapter adapter = new KnxEdgeAdapter();
        DataPoint canonical = DataPoint.builder()
                .name("室温")
                .config("{\"groupAddress\":\"1/2/3\",\"dpt\":\"9.1\"}")
                .build();
        DataPoint legacy = DataPoint.builder()
                .name("开关")
                .config("{\"group_address\":\"1/2/4\",\"dpt_id\":\"1.001\"}")
                .build();

        KnxPoint temperature = adapter.parsePoint(canonical);
        temperature.validateAndPrepare(canonical.getName());
        KnxPoint switchPoint = adapter.parsePoint(legacy);
        switchPoint.validateAndPrepare(legacy.getName());

        assertEquals("1/2/3", temperature.getGroupAddress());
        assertEquals("9.001", temperature.getDpt());
        assertEquals("1.001", switchPoint.getDpt());
    }

    private static EdgeDeviceConfig config(String configuration) {
        return new EdgeDeviceConfig() {
            @Override
            public String getId() {
                return "knx-gateway-1";
            }

            @Override
            public String getName() {
                return "KNX 网关";
            }

            @Override
            public String getProtocolId() {
                return "knx";
            }

            @Override
            public String getConfiguration() {
                return configuration;
            }
        };
    }
}
