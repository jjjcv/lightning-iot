package com.ruoyi.iot.plugin.bacnet;

import com.serotonin.bacnet4j.obj.ObjectProperties;
import com.serotonin.bacnet4j.obj.ObjectPropertyTypeDefinition;
import com.serotonin.bacnet4j.type.Encodable;
import com.serotonin.bacnet4j.type.constructed.SequenceOf;
import com.serotonin.bacnet4j.type.enumerated.BinaryPV;
import com.serotonin.bacnet4j.type.primitive.CharacterString;
import com.serotonin.bacnet4j.type.primitive.Enumerated;
import com.serotonin.bacnet4j.type.primitive.Null;
import com.serotonin.bacnet4j.type.primitive.OctetString;
import com.serotonin.bacnet4j.type.primitive.Real;
import com.serotonin.bacnet4j.type.primitive.SignedInteger;
import com.serotonin.bacnet4j.type.primitive.UnsignedInteger;

import java.lang.reflect.Method;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;

/** BACnet4J Encodable 与平台通用 Java 值之间的转换。 */
final class BacnetValueConverter {

    private BacnetValueConverter() {
    }

    static Object fromBacnet(Encodable value, String platformType) {
        if (value == null || value instanceof Null) {
            return null;
        }
        if (value instanceof com.serotonin.bacnet4j.type.primitive.Boolean bool) {
            return bool.booleanValue();
        }
        if (value instanceof BinaryPV binary) {
            return binary.intValue() != 0;
        }
        if (value instanceof UnsignedInteger number) {
            BigInteger integer = number.bigIntegerValue();
            return integer.bitLength() < 63 ? integer.longValue() : integer;
        }
        if (value instanceof SignedInteger number) {
            BigInteger integer = number.bigIntegerValue();
            return integer.bitLength() < 63 ? integer.longValue() : integer;
        }
        if (value instanceof Real number) {
            return number.floatValue();
        }
        if (value instanceof com.serotonin.bacnet4j.type.primitive.Double number) {
            return number.doubleValue();
        }
        if (value instanceof CharacterString text) {
            return text.getValue();
        }
        if (value instanceof OctetString octets) {
            return octets.getBytes();
        }
        if (value instanceof Enumerated enumerated) {
            return "boolean".equalsIgnoreCase(platformType) ? enumerated.intValue() != 0 : enumerated.intValue();
        }
        if (value instanceof SequenceOf<?> sequence) {
            List<Object> converted = new ArrayList<>();
            for (Object element : sequence.getValues()) {
                converted.add(element instanceof Encodable encodable
                        ? fromBacnet(encodable, null) : element);
            }
            return converted;
        }
        return value.toString();
    }

    static Encodable toBacnet(Object value, BacnetPoint point) {
        if (value == null) {
            return Null.instance;
        }

        ObjectPropertyTypeDefinition definition = ObjectProperties.getObjectPropertyTypeDefinition(
                point.getParsedObjectIdentifier().getObjectType(), point.getParsedPropertyIdentifier());
        if (definition == null) {
            throw new IllegalArgumentException("该 BACnet 对象不支持标准 presentValue 写入");
        }
        Class<? extends Encodable> type = definition.getPropertyTypeDefinition().getClazz();
        if (type == com.serotonin.bacnet4j.type.primitive.Boolean.class) {
            return com.serotonin.bacnet4j.type.primitive.Boolean.valueOf(booleanValue(value));
        }
        if (type == UnsignedInteger.class) {
            return new UnsignedInteger(bigInteger(value));
        }
        if (type == SignedInteger.class) {
            return new SignedInteger(bigInteger(value));
        }
        if (type == Real.class) {
            return new Real(number(value).floatValue());
        }
        if (type == com.serotonin.bacnet4j.type.primitive.Double.class) {
            return new com.serotonin.bacnet4j.type.primitive.Double(number(value).doubleValue());
        }
        if (type == CharacterString.class) {
            return new CharacterString(value.toString());
        }
        if (type == OctetString.class) {
            return new OctetString(bytes(value));
        }
        if (Enumerated.class.isAssignableFrom(type)) {
            return enumerated(type, value);
        }
        throw new IllegalArgumentException("暂不支持写入的 BACnet Present Value 类型：" + type.getSimpleName());
    }

    private static Encodable enumerated(Class<? extends Encodable> type, Object value) {
        int id = booleanValueOrNumber(value);
        try {
            Method factory = type.getMethod("forId", int.class);
            return (Encodable) factory.invoke(null, id);
        } catch (ReflectiveOperationException e) {
            throw new IllegalArgumentException("无法创建 BACnet 枚举类型 " + type.getSimpleName(), e);
        }
    }

    private static int booleanValueOrNumber(Object value) {
        if (value instanceof java.lang.Boolean bool) {
            return bool ? 1 : 0;
        }
        String text = value.toString().trim();
        if ("true".equalsIgnoreCase(text) || "active".equalsIgnoreCase(text)) {
            return 1;
        }
        if ("false".equalsIgnoreCase(text) || "inactive".equalsIgnoreCase(text)) {
            return 0;
        }
        return number(value).intValue();
    }

    private static boolean booleanValue(Object value) {
        if (value instanceof java.lang.Boolean bool) {
            return bool;
        }
        String text = value.toString().trim();
        return switch (text.toLowerCase(Locale.ROOT)) {
            case "1", "true", "yes", "on", "active", "是" -> true;
            case "0", "false", "no", "off", "inactive", "否" -> false;
            default -> throw new IllegalArgumentException("无法转换为布尔值：" + value);
        };
    }

    private static Number number(Object value) {
        if (value instanceof Number number) {
            return number;
        }
        String text = value.toString().trim();
        return text.contains(".") || text.contains("e") || text.contains("E")
                ? java.lang.Double.parseDouble(text) : Long.parseLong(text);
    }

    private static BigInteger bigInteger(Object value) {
        return value instanceof BigInteger integer ? integer : new BigInteger(value.toString().trim());
    }

    private static byte[] bytes(Object value) {
        if (value instanceof byte[] bytes) {
            return bytes;
        }
        return Base64.getDecoder().decode(value.toString().trim());
    }

}
