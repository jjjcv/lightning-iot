package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 网关数据点位统计对象
 *
 * online/offline 按所属网关（edge_device.link_status）连接状态统计：
 * 数据点位归属的网关在线则计入 online，离线则计入 offline。
 *
 * @author ruoyi
 * @date 2025-02-19
 */
@Schema(description = "网关数据点位统计对象")
public class EdgeDataPointStatistics {

    @Schema(description = "数据点位总数")
    private Long total;

    @Schema(description = "所属网关在线的数据点位数量（link_status = online）")
    private Long online;

    @Schema(description = "所属网关离线的数据点位数量（link_status = offline）")
    private Long offline;

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

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("total", getTotal())
            .append("online", getOnline())
            .append("offline", getOffline())
            .toString();
    }
}
