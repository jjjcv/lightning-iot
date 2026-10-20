package com.ruoyi.iot.plugin.opcua;

import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValidateResult;
import org.eclipse.milo.opcua.stack.core.NodeIds;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class OpcUaEdgeAdapterConfigTest {

    @Test
    void acceptsBareHostAndUsesDefaultPort() {
        JSONObject config = new JSONObject();
        config.put("endpoint", "192.168.1.10");

        assertEquals("opc.tcp://192.168.1.10:4840", OpcUaEdgeAdapter.resolveEndpointUrl(config));
    }

    @Test
    void acceptsCompactHostPortAndPath() {
        JSONObject config = new JSONObject();
        config.put("endpoint", "opc-server.local:62541/milo");

        assertEquals("opc.tcp://opc-server.local:62541/milo",
                OpcUaEdgeAdapter.resolveEndpointUrl(config));
    }

    @Test
    void keepsLegacyConnectionStringCompatible() {
        JSONObject config = new JSONObject();
        config.put("connection_string", "opcua:tcp://127.0.0.1:4840?discovery=true");

        assertEquals("opc.tcp://127.0.0.1:4840", OpcUaEdgeAdapter.resolveEndpointUrl(config));
    }

    @Test
    void takesOpcUaDataTypeFromDataPointType() {
        DataType dataType = new DataType() {
            @Override
            public String getId() {
                return "double";
            }

            @Override
            public String getName() {
                return "双精度浮点数";
            }

            @Override
            public String getDescription() {
                return null;
            }

            @Override
            public ValidateResult validate(Object value) {
                return ValidateResult.success(value);
            }

            @Override
            public Object format(Object value) {
                return value;
            }
        };
        DataPoint dataPoint = DataPoint.builder()
                .type(dataType)
                .config("{\"node_id\":\"ns=2;s=Temperature\",\"data_type\":\"String\"}")
                .build();

        OpcUaPoint point = new OpcUaEdgeAdapter().parsePoint(dataPoint);

        assertEquals("double", point.getPlatformDataType());
    }

    @Test
    void mapsOpcUaBuiltInTypesToPlatformTypes() {
        assertEquals("boolean", OpcUaEdgeAdapter.platformDataType(NodeIds.Boolean));
        assertEquals("short", OpcUaEdgeAdapter.platformDataType(NodeIds.Int16));
        assertEquals("int", OpcUaEdgeAdapter.platformDataType(NodeIds.UInt16));
        assertEquals("long", OpcUaEdgeAdapter.platformDataType(NodeIds.UInt32));
        assertEquals("float", OpcUaEdgeAdapter.platformDataType(NodeIds.Float));
        assertEquals("double", OpcUaEdgeAdapter.platformDataType(NodeIds.Double));
        assertEquals("date", OpcUaEdgeAdapter.platformDataType(NodeIds.DateTime));
        assertEquals("string", OpcUaEdgeAdapter.platformDataType(NodeIds.String));
    }

    @Test
    void createsCompleteDiscoveredPointConfig() {
        String json = OpcUaEdgeAdapter.discoveredPointConfig(
                "ns=3;i=1002", "Temperature", "温度", NodeIds.Double, Unsigned.ubyte(3));
        JSONObject config = JSONObject.parseObject(json);

        assertEquals("ns=3;i=1002", config.getString("nodeId"));
        assertEquals("Temperature", config.getString("browseName"));
        assertEquals("温度", config.getString("displayName"));
        assertEquals("Double", config.getString("dataType"));
        assertEquals("ns=0;i=11", config.getString("dataTypeNodeId"));
        assertEquals("Read/Write", config.getString("accessLevel"));
        assertEquals(true, config.getBooleanValue("writable"));
    }

    @Test
    void parsesCompleteCamelCasePointConfigAndKeepsLegacyNodeIdCompatible() {
        DataPoint dataPoint = DataPoint.builder()
                .config("{\"nodeId\":\"ns=3;i=1002\",\"browseName\":\"Temperature\","
                        + "\"displayName\":\"温度\",\"dataType\":\"Double\","
                        + "\"dataTypeNodeId\":\"ns=0;i=11\",\"accessLevel\":\"Read/Write\","
                        + "\"writable\":true}")
                .build();

        OpcUaPoint point = new OpcUaEdgeAdapter().parsePoint(dataPoint);

        assertEquals("ns=3;i=1002", point.getNodeId());
        assertEquals("Temperature", point.getBrowseName());
        assertEquals("温度", point.getDisplayName());
        assertEquals("Double", point.getDataType());
        assertEquals("ns=0;i=11", point.getDataTypeNodeId());
        assertEquals("Read/Write", point.getAccessLevel());
        assertEquals(true, point.isWritable());

        DataPoint legacy = DataPoint.builder().config("{\"node_id\":\"ns=2;s=Legacy\"}").build();
        assertEquals("ns=2;s=Legacy", new OpcUaEdgeAdapter().parsePoint(legacy).getNodeId());
    }
}
