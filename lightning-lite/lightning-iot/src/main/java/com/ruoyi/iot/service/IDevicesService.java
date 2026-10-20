package com.ruoyi.iot.service;

import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.DeviceStatistics;
import com.ruoyi.iot.edge.DataWriteResult;
import java.util.List;

/**
 * 设备Service接口
 *
 * @author ruoyi
 * @date 2025-02-25
 */
public interface IDevicesService {

    DataWriteResult write(String productId, String deviceId, String telemetryKey, String value);

    DataWriteResult write(String deviceId, String telemetryKey, String value);

    int countByProductId(String productId);

    /**
     * 设备统计：总数、在线、离线、启用、停用
     *
     * @return 设备统计结果
     */
    public DeviceStatistics selectDeviceStatistics();

    /**
     * 查询设备
     *
     * @param id 设备主键
     * @return 设备
     */
    public Device selectDevicesById(String id);

    /**
     * 查询设备列表
     *
     * @param device 设备
     * @return 设备集合
     */
    public List<Device> selectDevicesList(Device device);

    /**
     * 新增设备
     *
     * @param device 设备
     * @return 结果
     */
    public int insertDevices(Device device);

    /**
     * 修改设备
     *
     * @param device 设备
     * @return 结果
     */
    public int updateDevices(Device device);

    /**
     * 批量删除设备
     *
     * @param ids 需要删除的设备主键集合
     * @return 结果
     */
    public int deleteDevicesByIds(String[] ids);

    /**
     * 删除设备信息
     *
     * @param id 设备主键
     * @return 结果
     */
    public int deleteDevicesById(String id);

    /**
     * 导入设备数据
     *
     * @param deviceList 设备数据列表
     * @param isUpdateSupport 是否更新已存在设备
     * @param operName 操作用户
     * @return 结果
     */
    public String importDevices(List<Device> deviceList, boolean isUpdateSupport, String operName);
}
