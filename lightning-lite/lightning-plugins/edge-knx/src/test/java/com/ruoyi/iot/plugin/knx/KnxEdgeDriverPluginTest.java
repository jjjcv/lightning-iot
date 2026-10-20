package com.ruoyi.iot.plugin.knx;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotSame;

class KnxEdgeDriverPluginTest {

    @Test
    void factoryUsesStableProtocolIdAndCreatesDedicatedAdapters() {
        KnxEdgeDriverPlugin.KnxDriverFactory factory = new KnxEdgeDriverPlugin.KnxDriverFactory();

        assertEquals("knx", factory.getProtocolId());
        assertEquals("KNXnet/IP (Calimero)", factory.getProtocolName());
        Object first = factory.createAdapter();
        Object second = factory.createAdapter();
        assertInstanceOf(KnxEdgeAdapter.class, first);
        assertNotSame(first, second);
    }
}
