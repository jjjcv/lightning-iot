package com.ruoyi.iot.plugin.bacnet;

import com.ruoyi.iot.edge.DataPoint;
import com.serotonin.bacnet4j.type.enumerated.ObjectType;
import com.serotonin.bacnet4j.type.enumerated.PropertyIdentifier;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class BacnetPointTest {

    @Test
    void parsesNamedStandardObjectAndDefaultsToPresentValue() {
        DataPoint dataPoint = DataPoint.builder().config("""
                {"deviceInstance":1001,"objectType":"analogInput","objectInstance":7}
                """).build();

        BacnetPoint point = new BacnetEdgeAdapter().parsePoint(dataPoint);
        point.validateAndPrepare();

        assertEquals(1001, point.getDeviceInstance());
        assertEquals(ObjectType.analogInput, point.getParsedObjectIdentifier().getObjectType());
        assertEquals(7, point.getParsedObjectIdentifier().getInstanceNumber());
        assertEquals(PropertyIdentifier.presentValue, point.getParsedPropertyIdentifier());
    }

    @Test
    void acceptsEnumObjectTypeAndWritePriority() {
        DataPoint dataPoint = DataPoint.builder().config("""
                {"deviceInstance":5,"objectType":"analogValue","objectInstance":9,"writePriority":8}
                """).build();

        BacnetPoint point = new BacnetEdgeAdapter().parsePoint(dataPoint);
        point.validateAndPrepare();

        assertEquals(ObjectType.analogValue, point.getParsedObjectIdentifier().getObjectType());
        assertEquals(9, point.getParsedObjectIdentifier().getInstanceNumber());
        assertEquals(PropertyIdentifier.presentValue, point.getParsedPropertyIdentifier());
        assertEquals(8, point.getWritePriority());
    }

    @Test
    void rejectsRemovedCompactObjectIdFormat() {
        DataPoint dataPoint = DataPoint.builder().config("""
                {"deviceInstance":1001,"objectId":"analogInput:7"}
                """).build();

        assertThrows(IllegalArgumentException.class, () -> new BacnetEdgeAdapter().parsePoint(dataPoint));
    }

    @Test
    void rejectsObjectTypeOutsideSupportedEnum() {
        DataPoint dataPoint = DataPoint.builder().config("""
                {"deviceInstance":1001,"objectType":"device","objectInstance":7}
                """).build();

        BacnetPoint point = new BacnetEdgeAdapter().parsePoint(dataPoint);
        assertThrows(IllegalArgumentException.class, point::validateAndPrepare);
    }

    @Test
    void rejectsInvalidWritePriority() {
        BacnetPoint point = new BacnetPoint();
        point.setDeviceInstance(1);
        point.setObjectType("analogOutput");
        point.setObjectInstance(2);
        point.setWritePriority(17);

        assertThrows(IllegalArgumentException.class, point::validateAndPrepare);
    }
}
