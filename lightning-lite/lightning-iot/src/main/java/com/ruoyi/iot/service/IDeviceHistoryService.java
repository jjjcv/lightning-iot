package com.ruoyi.iot.service;

import java.util.Date;
import java.util.List;
import com.ruoyi.iot.domain.DeviceHistory;
import org.apache.ibatis.annotations.Param;

/**
 * DeviceHistoryService接口
 * 
 * @author ruoyi
 * @date 2025-03-11
 */
public interface IDeviceHistoryService 
{
    List<DeviceHistory> getLastRecordsByDevice(DeviceHistory deviceHistory);

    /**
     * 统计匹配条件的时序 series 数量。
     *
     * @param deviceHistory 查询条件和时间范围
     * @return series cardinality
     */
    long getSeriesCardinality(DeviceHistory deviceHistory);

    /**
     * 查询DeviceHistory
     * 
     * @param id DeviceHistory主键
     * @return DeviceHistory
     */
    public DeviceHistory selectDeviceHistoryById(Long id);

    /**
     * 查询DeviceHistory列表
     * 
     * @param deviceHistory DeviceHistory
     * @return DeviceHistory集合
     */
    public List<DeviceHistory> selectDeviceHistoryList(DeviceHistory deviceHistory);

    /**
     * 新增DeviceHistory
     * 
     * @param deviceHistory DeviceHistory
     * @return 结果
     */
    public int insertDeviceHistory(DeviceHistory deviceHistory);

    /**
     * 修改DeviceHistory
     * 
     * @param deviceHistory DeviceHistory
     * @return 结果
     */
    public int updateDeviceHistory(DeviceHistory deviceHistory);

    /**
     * 批量删除DeviceHistory
     * 
     * @param ids 需要删除的DeviceHistory主键集合
     * @return 结果
     */
    public int deleteDeviceHistoryByIds(Long[] ids);

    /**
     * 删除DeviceHistory信息
     * 
     * @param id DeviceHistory主键
     * @return 结果
     */
    public int deleteDeviceHistoryById(Long id);

    public int insertBatch(List<DeviceHistory> deviceHistoryList);

    /**
     * 按产品删除早于指定时间的过期历史数据
     *
     * @param productId  产品ID
     * @param beforeTime 时间上限（不含）
     * @return 删除条数；无法精确计数时返回 0
     */
    public int deleteExpiredByProduct(String productId, Date beforeTime);
}
