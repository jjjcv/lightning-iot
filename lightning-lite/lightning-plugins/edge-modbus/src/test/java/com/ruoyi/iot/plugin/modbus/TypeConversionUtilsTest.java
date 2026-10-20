package com.ruoyi.iot.plugin.modbus;

import org.junit.jupiter.api.Test;

import java.nio.ByteOrder;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;

class TypeConversionUtilsTest {

    @Test
    void encodesIntUsingConfiguredByteOrder() {
        assertArrayEquals(
                new byte[]{0x01, 0x02, 0x03, 0x04},
                TypeConversionUtils.intToByteArray(0x01020304, ByteOrder.BIG_ENDIAN));
        assertArrayEquals(
                new byte[]{0x04, 0x03, 0x02, 0x01},
                TypeConversionUtils.intToByteArray(0x01020304, ByteOrder.LITTLE_ENDIAN));
    }

    @Test
    void preservesLegacyRegisterWordConversion() {
        assertArrayEquals(
                new int[]{0x0102, 0x0304},
                TypeConversionUtils.intToShortArray(0x01020304, ByteOrder.BIG_ENDIAN));
    }
}
