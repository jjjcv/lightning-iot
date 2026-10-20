package com.ruoyi.iot.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.service.IDeviceHistoryService;
import com.ruoyi.iot.service.IDeviceHistoryStorageStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * DeviceHistoryService业务层处理
 * 
 * @author ruoyi
 * @date 2025-03-11
 */
@Service
public class DeviceHistoryServiceImpl implements IDeviceHistoryService 
{
    @Autowired
    private IDeviceHistoryStorageStrategy storageStrategy;


    /**
     * 获取指定设备的时间窗口数据
     *
     * @param deviceHistory DeviceHistory
     * @return DeviceHistory
     */
    @Override
    public List<DeviceHistory> getLastRecordsByDevice(DeviceHistory deviceHistory)
    {
        return storageStrategy.getLastRecordsByDevice(deviceHistory);
    }

    @Override
    public long getSeriesCardinality(DeviceHistory deviceHistory)
    {
        return storageStrategy.getSeriesCardinality(deviceHistory);
    }


    /**
     * 查询DeviceHistory
     * 
     * @param id DeviceHistory主键
     * @return DeviceHistory
     */
    @Override
    public DeviceHistory selectDeviceHistoryById(Long id)
    {
        return storageStrategy.selectDeviceHistoryById(id);
    }

    /**
     * 查询DeviceHistory列表
     * 
     * @param deviceHistory DeviceHistory
     * @return DeviceHistory
     */
    @Override
    public List<DeviceHistory> selectDeviceHistoryList(DeviceHistory deviceHistory)
    {
        return storageStrategy.selectDeviceHistoryList(deviceHistory);
    }

    /**
     * 新增DeviceHistory
     * 
     * @param deviceHistory DeviceHistory
     * @return 结果
     */
    @Override
    public int insertDeviceHistory(DeviceHistory deviceHistory)
    {
        return storageStrategy.insertDeviceHistory(deviceHistory);
    }

    /**
     * 修改DeviceHistory
     * 
     * @param deviceHistory DeviceHistory
     * @return 结果
     */
    @Override
    public int updateDeviceHistory(DeviceHistory deviceHistory)
    {
        // InfluxDB不支持更新操作，MySQL支持
        // 这里可以根据需要实现更新逻辑
        throw new UnsupportedOperationException("当前存储策略不支持更新操作");
    }

    /**
     * 批量删除DeviceHistory
     * 
     * @param ids 需要删除的DeviceHistory主键
     * @return 结果
     */
    @Override
    public int deleteDeviceHistoryByIds(Long[] ids)
    {
        return storageStrategy.deleteDeviceHistoryByIds(ids);
    }

    /**
     * 删除DeviceHistory信息
     * 
     * @param id DeviceHistory主键
     * @return 结果
     */
    @Override
    public int deleteDeviceHistoryById(Long id)
    {
        return storageStrategy.deleteDeviceHistoryById(id);
    }

    @Override
    public int insertBatch(List<DeviceHistory> deviceHistoryList){
        return storageStrategy.insertBatch(deviceHistoryList);
    }

    /**
     * 按产品删除早于指定时间的过期历史数据
     *
     * @param productId  产品ID
     * @param beforeTime 时间上限（不含）
     * @return 删除条数；无法精确计数时返回 0
     */
    @Override
    public int deleteExpiredByProduct(String productId, Date beforeTime)
    {
        return storageStrategy.deleteExpiredByProduct(productId, beforeTime);
    }
}
