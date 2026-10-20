package com.ruoyi.iot.plugin.modbus;

import java.util.Locale;

/**
 * Modbus 寄存器类型。
 *
 * <p>统一各类寄存器类型的常量定义，避免在 switch/比较时使用易出错的大小写敏感字符串。
 * 配置中可能以任意大小写给出（"holding" / "HOLDING" / "Holding"），{@link #from(String)}
 * 会做大小写不敏感解析。
 */
public enum RegisterType {

    /** 保持寄存器，可读可写。 */
    HOLDING("holding"),
    /** 输入寄存器，只读。 */
    INPUT("input"),
    /** 线圈，可读可写（位）。 */
    COIL("coil"),
    /** 离散输入，只读（位）。 */
    DISCRETE("discrete");

    private final String code;

    RegisterType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * 大小写不敏感地解析寄存器类型。
     *
     * @param raw 原始字符串（允许为 null/空白）
     * @return 对应枚举；无法识别时抛出 {@link IllegalArgumentException}
     */
    public static RegisterType from(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException("寄存器类型不能为空");
        }
        String normalized = raw.trim().toLowerCase(Locale.ROOT);
        for (RegisterType type : values()) {
            if (type.code.equals(normalized)) {
                return type;
            }
        }
        throw new IllegalArgumentException("未知的寄存器类型: " + raw);
    }
}
