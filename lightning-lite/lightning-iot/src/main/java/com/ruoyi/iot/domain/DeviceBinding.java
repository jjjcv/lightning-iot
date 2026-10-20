package com.ruoyi.iot.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NonNull;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 设备属性模板对象 device_binding
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "设备属性模板对象 device_binding") // 类级注解
public class DeviceBinding extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @Schema(description = "主键ID")
    private String id;

    /** 产品id */
    @Excel(name = "产品id")
    @Schema(description = "产品ID")
    private String productId;

    /** 产品name */
    @Excel(name = "产品name")
    @Schema(description = "产品name")
    private String productName;

    /** 设备id */
    @Excel(name = "设备id")
    @Schema(description = "设备ID")
    private String deviceId;

    /** 设备name */
    @Excel(name = "设备name")
    @Schema(description = "设备name")
    private String deviceName;


    /** 物模型id */
    @Excel(name = "物模型id")
    @Schema(description = "物模型ID")
    private String productTemplateId;

    /** 物模型（属性）标识 */
    @Excel(name = "物模型")
    @Schema(description = "物模型标识")
    private String telemetryKey;

    /** 网关唯一id */
    @Excel(name = "网关唯一id")
    @Schema(description = "网关唯一ID")
    private String gatewayId;

    /** 网关名称 */
    @Excel(name = "网关名称")
    @Schema(description = "网关名称")
    private String gatewayName;

    /** 网关数据点位id */
    @Excel(name = "网关数据点位id")
    @Schema(description = "网关数据点位ID")
    private String edgePointId;

    /** 网关数据点位名称 */
    @Excel(name = "网关数据点位名称")
    @Schema(description = "网关数据点位名称")
    private String edgePointName;

    /** 点位值 */
    @Schema(description = "点位值")
    private String value;

    /** 数据类型 */
    @Excel(name = "数据类型")
    @Schema(description = "数据类型")
    private String dataType;

    /** 单位符号 */
    @Excel(name = "单位符号")
    @Schema(description = "单位符号")
    private String unitSymbol;

    /** 点位值更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "点位值更新时间")
    private Date lastTime;
}
