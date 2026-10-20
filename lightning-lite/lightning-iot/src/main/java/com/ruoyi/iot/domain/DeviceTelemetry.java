package com.ruoyi.iot.domain;

import lombok.Data;

/**
 * 设备属性模板对象 device_binding
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Data
public class DeviceTelemetry {

    /** 产品id */
    private String productId;

    /** 设备id */
    private String deviceId;

    /** 物模型（属性）标识 */
    private String telemetryKey;

    /** 组件标识 */
    private String componentId;


}
