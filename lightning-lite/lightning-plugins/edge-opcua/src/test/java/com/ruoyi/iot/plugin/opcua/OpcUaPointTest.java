package com.ruoyi.iot.plugin.opcua;

import org.eclipse.milo.opcua.stack.core.types.builtin.NodeId;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class OpcUaPointTest {

    @Test
    void parsesStandardNodeId() {
        OpcUaPoint point = new OpcUaPoint();
        point.setNodeId("ns=2;s=Machine/Temperature");

        assertEquals(NodeId.parse("ns=2;s=Machine/Temperature"), point.parseNodeId());
    }

    @Test
    void trimsStandardNodeId() {
        OpcUaPoint point = new OpcUaPoint();
        point.setNodeId("  ns=3;i=1001  ");

        assertEquals(new NodeId(3, 1001), point.parseNodeId());
    }

    @Test
    void rejectsMissingNodeId() {
        assertThrows(IllegalArgumentException.class, new OpcUaPoint()::parseNodeId);
    }
}
