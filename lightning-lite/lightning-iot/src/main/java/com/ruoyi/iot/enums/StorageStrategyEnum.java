package com.ruoyi.iot.enums;

/**
 * 设备历史数据存储策略枚举
 * 
 * @author ruoyi
 */
public enum StorageStrategyEnum {
    /**
     * MySQL存储
     */
    MYSQL("mysql", "MySQL关系型数据库存储"),
    
    /**
     * InfluxDB存储
     */
    INFLUXDB("influxdb", "InfluxDB时序数据库存储");

    private final String code;
    private final String description;

    StorageStrategyEnum(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    /**
     * 根据code获取枚举
     */
    public static StorageStrategyEnum getByCode(String code) {
        for (StorageStrategyEnum strategy : values()) {
            if (strategy.getCode().equals(code)) {
                return strategy;
            }
        }
        throw new IllegalArgumentException("未知的存储策略: " + code);
    }
}
