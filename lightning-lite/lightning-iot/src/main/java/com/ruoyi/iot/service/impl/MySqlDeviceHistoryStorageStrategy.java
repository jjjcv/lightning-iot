package com.ruoyi.iot.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.enums.StorageStrategyEnum;
import com.ruoyi.iot.mapper.DeviceHistoryMapper;
import com.ruoyi.iot.service.IDeviceHistoryStorageStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * MySQL存储策略实现
 * 
 * @author ruoyi
 */
@Service
@ConditionalOnProperty(name = "device.history.storage.strategy", havingValue = "mysql", matchIfMissing = true)
public class MySqlDeviceHistoryStorageStrategy implements IDeviceHistoryStorageStrategy {
    
    @Autowired
    private DeviceHistoryMapper deviceHistoryMapper;
    
    @Override
    public String getStrategyName() {
        return StorageStrategyEnum.MYSQL.getCode();
    }
    
    @Override
    public List<DeviceHistory> selectDeviceHistoryList(DeviceHistory deviceHistory) {
        return deviceHistoryMapper.selectDeviceHistoryList(deviceHistory);
    }
    
    @Override
    public DeviceHistory selectDeviceHistoryById(Long id) {
        return deviceHistoryMapper.selectDeviceHistoryById(id);
    }

    @Override
    public DeviceHistory selectLatestReadingBefore(DeviceHistory deviceHistory, Date beforeTime) {
        validateLatestReadingQuery(deviceHistory, beforeTime);
        return deviceHistoryMapper.selectLatestReadingBefore(deviceHistory, beforeTime);
    }
    
    @Override
    public List<DeviceHistory> getLastRecordsByDevice(DeviceHistory deviceHistory) {
        return deviceHistoryMapper.selectLastRecordByTimeWindow(deviceHistory);
    }
    
    @Override
    public int insertBatch(List<DeviceHistory> deviceHistoryList) {
        if (deviceHistoryList == null || deviceHistoryList.isEmpty()) {
            return 0;
        }
        return deviceHistoryMapper.insertBatch(deviceHistoryList);
    }
    
    @Override
    public int insertDeviceHistory(DeviceHistory deviceHistory) {
        deviceHistory.setCreateTime(DateUtils.getNowDate());
        return deviceHistoryMapper.insertDeviceHistory(deviceHistory);
    }
    
    @Override
    public int deleteDeviceHistoryByIds(Long[] ids) {
        return deviceHistoryMapper.deleteDeviceHistoryByIds(ids);
    }
    
    @Override
    public int deleteDeviceHistoryById(Long id) {
        return deviceHistoryMapper.deleteDeviceHistoryById(id);
    }

    @Override
    public int deleteExpiredByProduct(String productId, Date beforeTime) {
        if (productId == null || productId.isEmpty() || beforeTime == null) {
            return 0;
        }
        return deviceHistoryMapper.deleteExpiredByProduct(productId, beforeTime);
    }

    private void validateLatestReadingQuery(DeviceHistory deviceHistory, Date beforeTime) {
        if (deviceHistory == null) {
            throw new IllegalArgumentException("查询条件不能为空");
        }
        if (beforeTime == null) {
            throw new IllegalArgumentException("时间上限不能为空");
        }
    }
}
