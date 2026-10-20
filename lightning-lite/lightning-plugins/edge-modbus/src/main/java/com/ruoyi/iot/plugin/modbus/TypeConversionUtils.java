package com.ruoyi.iot.plugin.modbus;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class TypeConversionUtils {

    public static int[] intToShortArray(Integer value) {
        return intToShortArray(value, ByteOrder.BIG_ENDIAN);
    }

    public static int[] floatToShortArray(Float value) {
        return floatToShortArray(value, ByteOrder.BIG_ENDIAN);
    }

    public static int[] doubleToShortArray(Double value) {
        return doubleToShortArray(value, ByteOrder.BIG_ENDIAN);
    }

    public static int[] longToShortArray(Long value) {
        return longToShortArray(value, ByteOrder.BIG_ENDIAN);
    }

    public static int[] intToShortArray(Integer value, ByteOrder byteOrder) {
        return toShortArray(intToByteArray(value, byteOrder));
    }

    public static int[] floatToShortArray(Float value, ByteOrder byteOrder) {
        return toShortArray(floatToByteArray(value, byteOrder));
    }

    public static int[] doubleToShortArray(Double value, ByteOrder byteOrder) {
        return toShortArray(doubleToByteArray(value, byteOrder));
    }

    public static int[] longToShortArray(Long value, ByteOrder byteOrder) {
        return toShortArray(longToByteArray(value, byteOrder));
    }

    public static byte[] intToByteArray(Integer value, ByteOrder byteOrder) {
        return ByteBuffer.allocate(4).order(byteOrder).putInt(value).array();
    }

    public static byte[] floatToByteArray(Float value, ByteOrder byteOrder) {
        return ByteBuffer.allocate(4).order(byteOrder).putFloat(value).array();
    }

    public static byte[] doubleToByteArray(Double value, ByteOrder byteOrder) {
        return ByteBuffer.allocate(8).order(byteOrder).putDouble(value).array();
    }

    public static byte[] longToByteArray(Long value, ByteOrder byteOrder) {
        return ByteBuffer.allocate(8).order(byteOrder).putLong(value).array();
    }

    private static int[] toShortArray(byte[] byteArray) {
        int[] shortArray = new int[byteArray.length / 2];
        for (int i = 0; i < shortArray.length; i++) {
            shortArray[i] = (int) ((byteArray[i * 2] << 8) | (byteArray[i * 2 + 1] & 0xFF));
        }
        return shortArray;
    }
}
