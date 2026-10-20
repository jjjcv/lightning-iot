package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 设备接入网关统计对象 edge_device_statistics
 *
 * @author ruoyi
 * @date 2025-02-14
 */
@Schema(description = "设备接入网关统计对象")
public class EdgeDeviceStatistics {

    @Schema(description = "设备接入网关总数")
    private Long total;

    @Schema(description = "在线网关数量（link_status = online）")
    private Long online;

    @Schema(description = "离线网关数量（link_status = offline）")
    private Long offline;

    @Schema(description = "启用网关数量（status = enable）")
    private Long enabled;

    @Schema(description = "停用网关数量（status = disable）")
    private Long disabled;

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

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("total", getTotal())
            .append("online", getOnline())
            .append("offline", getOffline())
            .append("enabled", getEnabled())
            .append("disabled", getDisabled())
            .toString();
    }
}
