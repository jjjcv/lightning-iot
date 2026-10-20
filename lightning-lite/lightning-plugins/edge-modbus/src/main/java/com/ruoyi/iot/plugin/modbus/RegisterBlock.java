package com.ruoyi.iot.plugin.modbus;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class RegisterBlock {
    int start; // 起始地址
    int totalQuantity; // 总寄存器数量
    RegisterType registerType;
    List<ModbusRegister> registers = new ArrayList<>();

    RegisterBlock(ModbusRegister reg) {
        this.registerType = reg.getRegisterTypeEnum();
        this.start = reg.getOffset();
        this.totalQuantity = reg.getQuantity();
        this.registers.add(reg);
    }

    int getEndExclusive() {
        return start + totalQuantity;
    }

    void add(ModbusRegister register) {
        registers.add(register);
        int registerEnd = register.getOffset() + register.getQuantity();
        totalQuantity = Math.max(getEndExclusive(), registerEnd) - start;
    }
}
