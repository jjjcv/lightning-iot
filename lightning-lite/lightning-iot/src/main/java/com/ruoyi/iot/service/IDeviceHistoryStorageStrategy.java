package com.ruoyi.iot.service;

import com.ruoyi.iot.domain.DeviceHistory;

import java.util.Date;
import java.util.List;

/**
 * 设备历史数据存储策略接口
 * 
 * @author ruoyi
 */
public interface IDeviceHistoryStorageStrategy {
    
    /**
     * 获取存储策略名称
     */
    String getStrategyName();
    
    /**
     * 查询设备历史数据列表
     * 
     * @param deviceHistory 查询条件
     * @return 设备历史数据集合
     */
    List<DeviceHistory> selectDeviceHistoryList(DeviceHistory deviceHistory);
    
    /**
     * 根据ID查询设备历史数据
     * 
     * @param id 主键
     * @return 设备历史数据
     */
    DeviceHistory selectDeviceHistoryById(Long id);

    /**
     * 查询指定时间之前的最新一条设备读数。
     *
     * @param deviceHistory 查询条件（产品、设备、物模型标识及数据类型）
     * @param beforeTime    时间上限（不含）
     * @return 最新读数；不存在时返回 {@code null}
     */
    DeviceHistory selectLatestReadingBefore(DeviceHistory deviceHistory, Date beforeTime);
    
    /**
     * 按设备查询时间窗口数据
     * 
     * @param deviceHistory 查询条件
     * @return 设备历史数据集合
     */
    List<DeviceHistory> getLastRecordsByDevice(DeviceHistory deviceHistory);

    /**
     * 统计当前存储中匹配条件的时序 series 数量。
     *
     * @param deviceHistory 查询条件和时间范围
     * @return series cardinality
     */
    default long getSeriesCardinality(DeviceHistory deviceHistory) {
        throw new UnsupportedOperationException("当前存储策略不支持 series cardinality 统计");
    }
    
    /**
     * 批量插入设备历史数据
     * 
     * @param deviceHistoryList 设备历史数据列表
     * @return 插入条数
     */
    int insertBatch(List<DeviceHistory> deviceHistoryList);
    
    /**
     * 插入单条设备历史数据
     * 
     * @param deviceHistory 设备历史数据
     * @return 插入条数
     */
    int insertDeviceHistory(DeviceHistory deviceHistory);
    
    /**
     * 删除设备历史数据
     * 
     * @param ids 需要删除的主键集合
     * @return 删除条数
     */
    int deleteDeviceHistoryByIds(Long[] ids);
    
    /**
     * 根据ID删除设备历史数据
     * 
     * @param id 主键
     * @return 删除条数
     */
    int deleteDeviceHistoryById(Long id);

    /**
     * 按产品删除早于指定时间的过期历史数据。
     *
     * @param productId  产品ID
     * @param beforeTime 删除该时间（不含）之前的数据
     * @return 删除条数；无法精确计数时返回 0（如 InfluxDB）
     */
    int deleteExpiredByProduct(String productId, Date beforeTime);
}
