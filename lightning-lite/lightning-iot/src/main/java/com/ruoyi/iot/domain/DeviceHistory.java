package com.ruoyi.iot.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

/**
 * DeviceHistory对象 device_history
 * 
 * @author ruoyi
 * @date 2025-03-11
 */
@Data
@Schema(description = "设备历史数据对象 device_history") // 类级注解
public class DeviceHistory extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @Schema(description = "主键ID")
    private Long id;

    /** 产品id */
    @Excel(name = "产品id")
    @Schema(description = "产品ID")
    private String productId;

    /** 设备id */
    @Excel(name = "设备id")
    @Schema(description = "设备ID")
    private String deviceId;

    /** 物模型（属性）标识 */
    @Excel(name = "物模型", readConverterExp = "属=性")
    @Schema(description = "物模型标识")
    private String telemetryKey;

    /** 点位值 */
    @Excel(name = "点位值")
    @Schema(description = "点位值")
    private String value;

    /** 数据类型 */
    @Excel(name = "数据类型")
    @Schema(description = "数据类型")
    private String dataType;

    /** 开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "查询开始时间")
    private Date startTime;

    /** 结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "查询结束时间")
    private Date endTime;

    /**
     * 查询时间间隔（单位：秒）
     */
    @Schema(description = "查询时间间隔（单位：秒）")
    private Long intervalSeconds;
}
