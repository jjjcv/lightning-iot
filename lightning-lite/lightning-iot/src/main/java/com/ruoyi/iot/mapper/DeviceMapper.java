package com.ruoyi.iot.mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;
import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.DeviceStatistics;

/**
 * 设备Mapper接口
 *
 * @author ruoyi
 * @date 2025-02-25
 */
public interface DeviceMapper
{
    /**
     * 查询产品下设备数量
     * @param productId
     * @return
     */
    public int countByProductId(@Param("productId") String productId);

    /**
     * 设备统计：总数、在线、离线、启用、停用
     *
     * @return 设备统计结果
     */
    public DeviceStatistics selectDeviceStatistics();

    /**
     * 设备类型数量统计：按 device_type 分组计数
     *
     * @return 每种设备类型对应的数量（deviceType -> count）
     */
    public List<Map<String, Object>> selectDeviceTypeCount();


    /**
     * 查询设备
     * 
     * @param id 设备主键
     * @return 设备
     */
    public Device selectDeviceById(String id);

    /**
     * 查询设备列表
     * 
     * @param device 设备
     * @return 设备集合
     */
    public List<Device> selectDeviceList(Device device);

    /**
     * 新增设备
     * 
     * @param device 设备
     * @return 结果
     */
    public int insertDevice(Device device);

    /**
     * 修改设备
     * 
     * @param device 设备
     * @return 结果
     */
    public int updateDevice(Device device);

    /**
     * 删除设备
     * 
     * @param id 设备主键
     * @return 结果
     */
    public int deleteDeviceById(String id);

    /**
     * 批量删除设备
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDevicesByIds(String[] ids);
}
