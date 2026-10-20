package com.ruoyi.iot.plugin.bacnet;

import com.serotonin.bacnet4j.type.enumerated.BinaryPV;
import com.serotonin.bacnet4j.type.primitive.Real;
import com.serotonin.bacnet4j.type.primitive.UnsignedInteger;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertTrue;

class BacnetValueConverterTest {

    @Test
    void convertsCommonIncomingValues() {
        assertEquals(12.5f, BacnetValueConverter.fromBacnet(new Real(12.5f), "float"));
        assertEquals(42L, BacnetValueConverter.fromBacnet(new UnsignedInteger(42), "long"));
        assertEquals(true, BacnetValueConverter.fromBacnet(BinaryPV.active, "boolean"));
    }

    @Test
    void infersStandardPresentValueEncoding() {
        BacnetPoint analog = point("analogValue");
        Object encoded = BacnetValueConverter.toBacnet("21.25", analog);

        assertInstanceOf(Real.class, encoded);
        assertEquals(21.25f, ((Real) encoded).floatValue());
    }

    @Test
    void writesBinaryPresentValueFromBoolean() {
        BacnetPoint binary = point("binaryOutput");
        Object encoded = BacnetValueConverter.toBacnet(true, binary);

        assertInstanceOf(BinaryPV.class, encoded);
        assertTrue(((BinaryPV) encoded).equals(BinaryPV.active));
    }

    private static BacnetPoint point(String objectType) {
        BacnetPoint point = new BacnetPoint();
        point.setDeviceInstance(1001);
        point.setObjectType(objectType);
        point.setObjectInstance(1);
        point.validateAndPrepare();
        return point;
    }
}
