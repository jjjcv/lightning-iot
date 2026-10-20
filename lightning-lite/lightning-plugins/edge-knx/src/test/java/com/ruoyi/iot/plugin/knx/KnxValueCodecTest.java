package com.ruoyi.iot.plugin.knx;

import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValidateResult;
import io.calimero.dptxlator.DPTXlator;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class KnxValueCodecTest {

    @Test
    void encodesAndDecodesBooleanDpt() throws Exception {
        DPTXlator on = KnxValueCodec.encode("1.001", true);
        DPTXlator off = KnxValueCodec.encode("1.001", false);

        assertTrue((Boolean) KnxValueCodec.decode("1.001", on.getData(), type("boolean")));
        assertFalse((Boolean) KnxValueCodec.decode("1.001", off.getData(), type("boolean")));
    }

    @Test
    void encodesAndDecodesTwoByteFloatWithoutUnitText() throws Exception {
        DPTXlator translator = KnxValueCodec.encode("9.001", 23.5);

        assertEquals(23.5,
                (Double) KnxValueCodec.decode("9.001", translator.getData(), type("double")),
                0.02);
    }

    @Test
    void castsNumericDptToPlatformIntegerType() throws Exception {
        DPTXlator translator = KnxValueCodec.encode("5.010", 42);

        assertEquals(42, KnxValueCodec.decode("5.010", translator.getData(), type("int")));
    }

    private static DataType type(String id) {
        return new DataType() {
            @Override
            public String getId() {
                return id;
            }

            @Override
            public String getName() {
                return id;
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
    }
}
