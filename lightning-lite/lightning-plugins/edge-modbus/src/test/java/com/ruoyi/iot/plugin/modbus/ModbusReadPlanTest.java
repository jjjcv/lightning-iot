package com.ruoyi.iot.plugin.modbus;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ModbusReadPlanTest {

    @Test
    void mergesOverlappingRegistersUsingAddressSpan() {
        ModbusEdgeAdapter adapter = new ModbusEdgeAdapter();

        List<RegisterBlock> blocks = adapter.buildReadPlan(List.of(
                register("first", RegisterType.HOLDING, 0, 2),
                register("second", RegisterType.HOLDING, 1, 2)));

        assertEquals(1, blocks.size());
        assertEquals(0, blocks.getFirst().getStart());
        assertEquals(3, blocks.getFirst().getTotalQuantity());
        assertEquals(2, blocks.getFirst().getRegisters().size());
    }

    @Test
    void includesConfiguredAddressGapInBlockQuantity() {
        ModbusEdgeAdapter adapter = new ModbusEdgeAdapter();
        adapter.setMaxBlockGap(1);

        List<RegisterBlock> blocks = adapter.buildReadPlan(List.of(
                register("first", RegisterType.HOLDING, 0, 1),
                register("second", RegisterType.HOLDING, 2, 1)));

        assertEquals(1, blocks.size());
        assertEquals(3, blocks.getFirst().getTotalQuantity());
    }

    @Test
    void doesNotReadAcrossAddressGapByDefault() {
        ModbusEdgeAdapter adapter = new ModbusEdgeAdapter();

        List<RegisterBlock> blocks = adapter.buildReadPlan(List.of(
                register("first", RegisterType.HOLDING, 0, 1),
                register("second", RegisterType.HOLDING, 2, 1)));

        assertEquals(2, blocks.size());
    }

    @Test
    void splitsBlocksAtConfiguredProtocolLimit() {
        ModbusEdgeAdapter adapter = new ModbusEdgeAdapter();
        adapter.setMaxBlockSize(3);

        List<RegisterBlock> blocks = adapter.buildReadPlan(List.of(
                register("first", RegisterType.HOLDING, 0, 2),
                register("second", RegisterType.HOLDING, 2, 2)));

        assertEquals(2, blocks.size());
    }

    private static ModbusRegister register(
            String id,
            RegisterType registerType,
            int offset,
            int quantity) {
        ModbusRegister register = new ModbusRegister();
        register.setId(id);
        register.setType("int");
        register.setRegisterType(registerType.getCode());
        register.setOffset(offset);
        register.setQuantity(quantity);
        return register;
    }
}
