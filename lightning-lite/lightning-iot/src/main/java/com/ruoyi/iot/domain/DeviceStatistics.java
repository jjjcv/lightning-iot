package com.ruoyi.iot.domain;

import java.util.Map;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 设备统计对象 devices_statistics
 *
 * @author ruoyi
 * @date 2025-02-25
 */
@Schema(description = "设备统计对象")
public class DeviceStatistics {

    @Schema(description = "设备总数")
    private Long total;

    @Schema(description = "在线设备数量（link_status = online）")
    private Long online;

    @Schema(description = "离线设备数量（link_status = offline）")
    private Long offline;

    @Schema(description = "启用设备数量（status = enable）")
    private Long enabled;

    @Schema(description = "停用设备数量（status = disable）")
    private Long disabled;

    @Schema(description = "设备类型数量统计（device_type -> 数量）")
    private Map<String, Long> deviceTypeCount;

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public Long getOnline() {
        return online;
    }

    public void setOnline(Long online) {
        this.online = online;
    }

    public Long getOffline() {
        return offline;
    }

    public void setOffline(Long offline) {
        this.offline = offline;
    }

    public Long getEnabled() {
        return enabled;
    }

    public void setEnabled(Long enabled) {
        this.enabled = enabled;
    }

    public Long getDisabled() {
        return disabled;
    }

    public void setDisabled(Long disabled) {
        this.disabled = disabled;
    }

    public Map<String, Long> getDeviceTypeCount() {
        return deviceTypeCount;
    }

    public void setDeviceTypeCount(Map<String, Long> deviceTypeCount) {
        this.deviceTypeCount = deviceTypeCount;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("total", getTotal())
            .append("online", getOnline())
            .append("offline", getOffline())
            .append("enabled", getEnabled())
            .append("disabled", getDisabled())
            .append("deviceTypeCount", getDeviceTypeCount())
            .toString();
    }
}
