package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.EdgeDeviceStatistics;

/**
 * 设备接入网关Mapper接口
 *
 * @author ruoyi
 * @date 2025-02-14
 */
public interface EdgeDeviceMapper
{
    /**
     * 设备接入网关统计：总数、在线、离线、启用、停用
     *
     * @return 设备接入网关统计结果
     */
    public EdgeDeviceStatistics selectEdgeDeviceStatistics();

    /**
     * 查询设备接入网关
     *
     * @param id 设备接入网关主键
     * @return 设备接入网关
     */
    public EdgeDevice selectEdgeDeviceById(String id);

    /**
     * 查询设备接入网关列表
     * 
     * @param edgeDevice 设备接入网关
     * @return 设备接入网关集合
     */
    public List<EdgeDevice> selectEdgeDeviceList(EdgeDevice edgeDevice);

    /**
     * 新增设备接入网关
     * 
     * @param edgeDevice 设备接入网关
     * @return 结果
     */
    public int insertEdgeDevice(EdgeDevice edgeDevice);

    /**
     * 修改设备接入网关
     * 
     * @param edgeDevice 设备接入网关
     * @return 结果
     */
    public int updateEdgeDevice(EdgeDevice edgeDevice);

    /**
     * 仅更新网关启停状态和更新时间。
     */
    public int updateEdgeDeviceStatus(EdgeDevice edgeDevice);

    /**
     * 删除设备接入网关
     * 
     * @param id 设备接入网关主键
     * @return 结果
     */
    public int deleteEdgeDeviceById(String id);

    /**
     * 批量删除设备接入网关
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteEdgeDeviceByIds(String[] ids);
}
