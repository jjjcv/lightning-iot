package com.ruoyi.iot.plugin.knx;

import com.ruoyi.iot.metadata.DataType;
import io.calimero.KNXException;
import io.calimero.dptxlator.DPTXlator;
import io.calimero.dptxlator.DPTXlatorBoolean;
import io.calimero.dptxlator.DPTXlatorDate;
import io.calimero.dptxlator.DPTXlatorDateTime;
import io.calimero.dptxlator.DPTXlatorTime;
import io.calimero.dptxlator.TranslatorTypes;

import java.util.Date;
import java.util.Locale;

/** Calimero DPT 值与平台 Java 值之间的转换。 */
final class KnxValueCodec {

    private KnxValueCodec() {
    }

    static Object decode(String dpt, byte[] asdu, DataType type) throws KNXException {
        DPTXlator translator = TranslatorTypes.createTranslator(dpt, asdu);
        translator.setAppendUnit(false);
        return decode(translator, type);
    }

    static Object decode(DPTXlator translator, DataType type) throws KNXException {
        String typeId = type == null || type.getType() == null
                ? ""
                : type.getType().toLowerCase(Locale.ROOT);
        if (translator instanceof DPTXlatorBoolean booleanTranslator) {
            return booleanTranslator.getValueBoolean();
        }
        if ("date".equals(typeId)) {
            return new Date((long) translator.getNumericValue());
        }
        if (isNumericType(typeId)) {
            return castNumber(translator.getNumericValue(), typeId);
        }
        if (typeId.isEmpty()) {
            try {
                return translator.getNumericValue();
            } catch (Exception ignored) {
                // Some compound DPTs intentionally have no scalar numeric representation.
            }
        }
        return translator.getValue();
    }

    static DPTXlator encode(String dpt, Object value) throws KNXException {
        if (value == null) {
            throw new IllegalArgumentException("KNX 下置值不能为 null");
        }
        DPTXlator translator = TranslatorTypes.createTranslator(dpt);
        translator.setAppendUnit(false);
        if (value instanceof Date date) {
            setDateValue(translator, date.getTime());
        } else if (value instanceof Boolean booleanValue) {
            if (translator instanceof DPTXlatorBoolean booleanTranslator) {
                booleanTranslator.setValue(booleanValue);
            } else {
                translator.setValue(booleanValue ? 1.0 : 0.0);
            }
        } else if (value instanceof Number number) {
            translator.setValue(number.doubleValue());
        } else {
            translator.setValue(value.toString());
        }
        return translator;
    }

    private static void setDateValue(DPTXlator translator, long millis) throws KNXException {
        if (translator instanceof DPTXlatorDate date) {
            date.setValue(millis);
        } else if (translator instanceof DPTXlatorTime time) {
            time.setValue(millis);
        } else if (translator instanceof DPTXlatorDateTime dateTime) {
            dateTime.setValue(millis);
        } else {
            translator.setValue(Long.toString(millis));
        }
    }

    private static boolean isNumericType(String typeId) {
        return switch (typeId) {
            case "short", "int", "long", "float", "double" -> true;
            default -> false;
        };
    }

    private static Object castNumber(double value, String typeId) {
        return switch (typeId) {
            case "short" -> (short) value;
            case "int" -> (int) value;
            case "long" -> (long) value;
            case "float" -> (float) value;
            default -> value;
        };
    }
}
