package com.ruoyi.iot.plugin.bacnet;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotSame;

class BacnetEdgeDriverPluginTest {

    @Test
    void factoryUsesStableProtocolIdAndCreatesDedicatedAdapters() {
        BacnetEdgeDriverPlugin.BacnetDriverFactory factory = new BacnetEdgeDriverPlugin.BacnetDriverFactory();

        assertEquals("bacnet", factory.getProtocolId());
        assertEquals("BACnet/IP (BACnet4J)", factory.getProtocolName());
        Object first = factory.createAdapter();
        Object second = factory.createAdapter();
        assertInstanceOf(BacnetEdgeAdapter.class, first);
        assertNotSame(first, second);
    }
}
