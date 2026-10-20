package com.ruoyi.iot.plugin.opcua;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotSame;

class OpcUaEdgeDriverPluginTest {

    @Test
    void factoryKeepsExistingProtocolIdAndCreatesDedicatedAdapters() {
        OpcUaEdgeDriverPlugin.OpcUaDriverFactory factory = new OpcUaEdgeDriverPlugin.OpcUaDriverFactory();

        assertEquals("opcua", factory.getProtocolId());
        assertEquals("OPC UA (Eclipse Milo)", factory.getProtocolName());
        Object first = factory.createAdapter();
        Object second = factory.createAdapter();
        assertInstanceOf(OpcUaEdgeAdapter.class, first);
        assertNotSame(first, second);
    }
}
