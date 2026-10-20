package com.ruoyi.iot.mapper;
import org.apache.ibatis.annotations.Param;
import java.util.Collection;
import java.util.Date;

import java.util.List;
import com.ruoyi.iot.domain.DeviceHistory;

/**
 * DeviceHistoryMapper接口
 * 
 * @author ruoyi
 * @date 2025-03-11
 */
public interface DeviceHistoryMapper 
{


    List<DeviceHistory> selectLastRecordByTimeWindow(DeviceHistory deviceHistory);

    /**
     * 查询DeviceHistory
     * 
     * @param id DeviceHistory主键
     * @return DeviceHistory
     */
    public DeviceHistory selectDeviceHistoryById(Long id);

    /**
     * 查询指定时间之前的最新一条设备读数
     *
     * @param deviceHistory 查询条件
     * @param beforeTime    时间上限（不含）
     * @return 最新读数；不存在时返回 null
     */
    DeviceHistory selectLatestReadingBefore(@Param("deviceHistory") DeviceHistory deviceHistory,
                                            @Param("beforeTime") Date beforeTime);

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


    public int insertBatch(@Param("deviceHistoryCollection") Collection<DeviceHistory> deviceHistoryCollection);

    /**
     * 修改DeviceHistory
     * 
     * @param deviceHistory DeviceHistory
     * @return 结果
     */
    public int updateDeviceHistory(DeviceHistory deviceHistory);

    /**
     * 删除DeviceHistory
     * 
     * @param id DeviceHistory主键
     * @return 结果
     */
    public int deleteDeviceHistoryById(Long id);

    /**
     * 批量删除DeviceHistory
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDeviceHistoryByIds(Long[] ids);

    /**
     * 按产品删除早于指定时间的历史数据
     *
     * @param productId  产品ID
     * @param beforeTime 时间上限（不含）
     * @return 删除条数
     */
    int deleteExpiredByProduct(@Param("productId") String productId, @Param("beforeTime") Date beforeTime);
}
