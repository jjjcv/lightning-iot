package com.ruoyi.iot.plugin.modbus;

import com.alibaba.fastjson2.annotation.JSONField;
import lombok.Data;

@Data
public class ModbusRegister {
    private String id;
    private String type;
    private int offset;
    private int quantity;
    @JSONField(name = "register_type")
    private String registerType;

    /**
     * 以枚举形式返回寄存器类型，大小写不敏感。
     */
    public RegisterType getRegisterTypeEnum() {
        return RegisterType.from(registerType);
    }
}
