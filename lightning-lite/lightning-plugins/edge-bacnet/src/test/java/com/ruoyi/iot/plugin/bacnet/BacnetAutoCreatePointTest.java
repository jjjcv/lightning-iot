package com.ruoyi.iot.plugin.bacnet;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.edge.DiscoveredDataPoint;
import com.serotonin.bacnet4j.type.enumerated.ObjectType;
import com.serotonin.bacnet4j.type.primitive.ObjectIdentifier;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class BacnetAutoCreatePointTest {

    @Test
    void createsReadablePointDescriptorFromAnalogInput() {
        DiscoveredDataPoint discovered = BacnetEdgeAdapter.toDiscoveredDataPoint(
                1001, new ObjectIdentifier(ObjectType.analogInput, 7), "Room Temperature");

        assertEquals("1001/analogInput/7/presentValue", discovered.key());
        assertEquals("1001/Room Temperature", discovered.name());
        assertEquals("float", discovered.type());
        assertEquals("r", discovered.operationType());
        JSONObject config = JSON.parseObject(discovered.config());
        assertEquals(1001, config.getIntValue("deviceInstance"));
        assertEquals("analogInput", config.getString("objectType"));
        assertEquals(7, config.getIntValue("objectInstance"));
        assertEquals(3, config.size());
    }

    @Test
    void marksOutputPointAsWritable() {
        DiscoveredDataPoint discovered = BacnetEdgeAdapter.toDiscoveredDataPoint(
                1001, new ObjectIdentifier(ObjectType.binaryOutput, 3), "Fan Command");

        assertEquals("boolean", discovered.type());
        assertEquals("w", discovered.operationType());
    }

    @Test
    void rejectsUnsupportedObjectType() {
        ObjectIdentifier device = new ObjectIdentifier(ObjectType.device, 1001);

        assertThrows(IllegalArgumentException.class,
                () -> BacnetEdgeAdapter.toDiscoveredDataPoint(1001, device, "Device"));
    }
}
