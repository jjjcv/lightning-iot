package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;

/** 单个标签直接关联的设备连接状态统计。 */
@Schema(description = "标签直接关联设备统计，使用 Redis 实时连接状态，无状态记录按离线处理")
public class TagDeviceStatistics {
    @Schema(description = "关联设备总数")
    private Long total;
    @Schema(description = "在线设备数（Redis 实时连接状态为 online）")
    private Long online;
    @Schema(description = "离线设备数（总数减在线数，含无状态记录设备）")
    private Long offline;

    public Long getTotal() { return total; }
    public void setTotal(Long total) { this.total = total; }
    public Long getOnline() { return online; }
    public void setOnline(Long online) { this.online = online; }
    public Long getOffline() { return offline; }
    public void setOffline(Long offline) { this.offline = offline; }
}
