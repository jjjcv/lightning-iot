package com.ruoyi.iot.edge;

/**
 * 边缘驱动从现场设备发现的数据点位。
 *
 * @param key           协议内稳定唯一键，例如 OPC UA NodeId
 * @param name          点位显示名称
 * @param type          平台数据类型
 * @param operationType 读写类型：r 读、w 写、p 上报
 * @param config        协议点位配置 JSON
 */
public record DiscoveredDataPoint(
        String key,
        String name,
        String type,
        String operationType,
        String config) {
}
