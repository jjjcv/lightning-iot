package com.ruoyi.iot.plugin.opcua;

import org.eclipse.milo.opcua.stack.core.types.builtin.ByteString;
import org.eclipse.milo.opcua.stack.core.types.builtin.DateTime;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.UInteger;
import org.junit.jupiter.api.Test;

import java.math.BigInteger;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertThrows;

class OpcUaValueConverterTest {

    @Test
    void convertsUnsignedValuesToPlatformNumbers() {
        assertEquals(4_294_967_295L,
                OpcUaValueConverter.fromMilo(UInteger.valueOf(4_294_967_295L)));
    }

    @Test
    void convertsConfiguredUnsignedWriteTypes() {
        assertEquals(UInteger.valueOf(4_294_967_295L),
                OpcUaValueConverter.toMilo("4294967295", "UInt32"));
        assertEquals(new BigInteger("18446744073709551615").toString(),
                OpcUaValueConverter.toMilo("18446744073709551615", "UInt64").toString());
    }

    @Test
    void convertsDateTimeAndByteString() {
        Instant instant = Instant.parse("2026-08-18T08:00:00Z");
        Object dateTime = OpcUaValueConverter.toMilo(instant, "DateTime");
        assertInstanceOf(DateTime.class, dateTime);
        assertEquals(Date.from(instant), OpcUaValueConverter.fromMilo(dateTime));

        byte[] expected = {1, 2, 3, 4};
        Object byteString = OpcUaValueConverter.toMilo(Base64.getEncoder().encodeToString(expected), "ByteString");
        assertInstanceOf(ByteString.class, byteString);
        assertArrayEquals(expected, (byte[]) OpcUaValueConverter.fromMilo(byteString));
    }

    @Test
    void rejectsUnknownConfiguredType() {
        assertThrows(IllegalArgumentException.class,
                () -> OpcUaValueConverter.toMilo("1", "Decimal128"));
    }
}
