package com.ruoyi.iot.plugin.opcua;

import org.eclipse.milo.opcua.stack.core.types.builtin.ByteString;
import org.eclipse.milo.opcua.stack.core.types.builtin.DateTime;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.UByte;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.UInteger;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.ULong;
import org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.UShort;

import java.math.BigInteger;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.Locale;
import java.util.UUID;

import static org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned.ubyte;
import static org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned.uint;
import static org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned.ulong;
import static org.eclipse.milo.opcua.stack.core.types.builtin.unsigned.Unsigned.ushort;

/** Milo 内建类型与平台通用 Java 类型之间的转换。 */
final class OpcUaValueConverter {

    private OpcUaValueConverter() {
    }

    static Object fromMilo(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof UByte number) {
            return number.intValue();
        }
        if (value instanceof UShort number) {
            return number.intValue();
        }
        if (value instanceof UInteger number) {
            return number.longValue();
        }
        if (value instanceof ULong number) {
            return new BigInteger(number.toString());
        }
        if (value instanceof DateTime dateTime) {
            return dateTime.getJavaDate();
        }
        if (value instanceof ByteString byteString) {
            return byteString.bytesOrEmpty();
        }
        if (value instanceof Object[] values) {
            Object[] converted = new Object[values.length];
            for (int i = 0; i < values.length; i++) {
                converted[i] = fromMilo(values[i]);
            }
            return converted;
        }
        return value;
    }

    static Object toMilo(Object value, String configuredType) {
        if (value == null || configuredType == null || configuredType.isBlank()) {
            return value;
        }

        String type = configuredType.replace("_", "")
                .replace("-", "")
                .trim()
                .toLowerCase(Locale.ROOT);
        return switch (type) {
            case "boolean", "bool" -> value instanceof Boolean b ? b : Boolean.parseBoolean(value.toString());
            case "sbyte", "int8" -> number(value).byteValue();
            case "byte", "uint8" -> ubyte(number(value).intValue());
            case "int16", "short" -> number(value).shortValue();
            case "uint16", "ushort" -> ushort(number(value).intValue());
            case "int32", "integer", "int" -> number(value).intValue();
            case "uint32", "uinteger" -> uint(number(value).longValue());
            case "int64", "long" -> number(value).longValue();
            case "uint64", "ulong" -> ulong(bigInteger(value));
            case "float", "float32" -> number(value).floatValue();
            case "double", "float64" -> number(value).doubleValue();
            case "string" -> value.toString();
            case "guid", "uuid" -> value instanceof UUID uuid ? uuid : UUID.fromString(value.toString());
            case "datetime", "date" -> toDateTime(value);
            case "bytestring", "bytes" -> toByteString(value);
            default -> throw new IllegalArgumentException("不支持的 OPC UA data_type: " + configuredType);
        };
    }

    private static Number number(Object value) {
        if (value instanceof Number number) {
            return number;
        }
        String text = value.toString().trim();
        return text.contains(".") || text.contains("e") || text.contains("E")
                ? Double.parseDouble(text)
                : Long.parseLong(text);
    }

    private static BigInteger bigInteger(Object value) {
        if (value instanceof BigInteger integer) {
            return integer;
        }
        return new BigInteger(value.toString().trim());
    }

    private static DateTime toDateTime(Object value) {
        if (value instanceof DateTime dateTime) {
            return dateTime;
        }
        if (value instanceof Date date) {
            return new DateTime(date);
        }
        if (value instanceof Instant instant) {
            return new DateTime(instant);
        }
        return new DateTime(Instant.parse(value.toString()));
    }

    private static ByteString toByteString(Object value) {
        if (value instanceof ByteString byteString) {
            return byteString;
        }
        if (value instanceof byte[] bytes) {
            return ByteString.of(bytes);
        }
        return ByteString.of(Base64.getDecoder().decode(value.toString()));
    }
}
