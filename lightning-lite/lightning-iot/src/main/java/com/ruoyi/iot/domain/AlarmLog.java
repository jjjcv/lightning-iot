package com.ruoyi.iot.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 告警记录对象 alarm_log
 *
 * @author ruoyi
 * @date 2025-09-10
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlarmLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 产品id */
    @Excel(name = "产品id")
    private String productId;

    /** 产品名称 */
    @Excel(name = "产品名称")
    private String productName;

    /** 设备id */
    @Excel(name = "设备id")
    private String deviceId;

    /** 设备名称 */
    @Excel(name = "设备名称")
    private String deviceName;

    /** 物模型（属性）标识 */
    @Excel(name = "物模型", readConverterExp = "属=性")
    private String telemetryKey;

    /** 属性名称 */
    @Excel(name = "属性名称")
    private String telemetryName;

    /** 属性值 */
    @Excel(name = "属性值")
    private String telemetryValue;

    /** 触发条件描述 */
    @Excel(name = "触发条件描述")
    private String triggerDesc;

    /** 告警描述 */
    @Excel(name = "告警描述")
    private String alarmDesc;

    /** 告警时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "告警时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date alarmTime;

    /** 处理说明 */
    @Excel(name = "处理说明")
    private String handleMessage;

    /** 处理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "处理时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date handleTime;

    /** 告警等级:1-严重 2-重要 3-一般 4-提示 */
    @Excel(name = "告警等级:1-严重 2-重要 3-一般 4-提示")
    private Integer level;

    /** 告警记录状态 */
    @Excel(name = "告警记录状态")
    private String state;

    /** 告警处理类型：告警状态:0-未确认 1-已确认 2-已恢复 3-已关闭 */
    @Excel(name = "告警处理类型：告警状态:0-未确认 1-已确认 2-已恢复 3-已关闭")
    private String handleType;

    /** 说明 */
    @Excel(name = "说明")
    private String description;


}
