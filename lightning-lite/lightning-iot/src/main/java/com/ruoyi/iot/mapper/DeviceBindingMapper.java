package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.DeviceBinding;
import org.apache.ibatis.annotations.Param;

/**
 * 设备属性模板Mapper接口
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
public interface DeviceBindingMapper 
{
    /**
     * 查询设备属性模板
     * 
     * @param id 设备属性模板主键
     * @return 设备属性模板
     */
    public DeviceBinding selectDeviceBindingById(String id);

    public DeviceBinding selectOneByProductIdAndDeviceIdAndTelemetryKey(@Param("productId") String productId, @Param("deviceId") String deviceId, @Param("telemetryKey") String telemetryKey);

    /**
     * 查询设备属性模板列表
     * 
     * @param deviceBinding 设备属性模板
     * @return 设备属性模板集合
     */
    public List<DeviceBinding> selectDeviceBindingList(DeviceBinding deviceBinding);

    public List<DeviceBinding> selectDeviceBindingListByDeviceIds(@Param("deviceIds") List<String> deviceIds);


    List<DeviceBinding> selectAllByEdgePointId(@Param("edgePointId") String edgePointId);

    List<DeviceBinding> selectAllByProductId(@Param("productId") String productId);

    List<DeviceBinding> selectAllByGatewayId(@Param("gatewayId") String gatewayId);

    List<DeviceBinding> selectAllByDeviceId(@Param("deviceId") String deviceId);
    /**
     * 新增设备属性模板
     * 
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    public int insertDeviceBinding(DeviceBinding deviceBinding);

    /**
     * 修改设备属性模板
     * 
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    public int updateDeviceBinding(DeviceBinding deviceBinding);

    /**
     * 删除设备属性模板
     * 
     * @param id 设备属性模板主键
     * @return 结果
     */
    public int deleteDeviceBindingById(String id);

    /**
     * 批量删除设备属性模板
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDeviceBindingByIds(String[] ids);

    /**
     * 批量更新设备属性模板
     *
     * @param batchList 设备属性模板
     * @return 结果
     */
    public int updateValueBatchById(@Param("batchList") List<DeviceBinding> batchList);

    /**
     * 根据设备id删除设备属性模板
     *
     * @param deviceId 设备id
     * @return 删除结果
     */
    public int deleteByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 根据设备属性模板id更新设备属性模板名称
     *
     * @param edgePointName 设备属性模板名称
     * @param edgePointId 设备属性模板id
     * @return 更新结果
     */
    public int updateEdgePointNameByEdgePointId(@Param("edgePointName") String edgePointName, @Param("edgePointId") String edgePointId);

    /**
     * 根据网关id更新网关名称
     *
     * @param gatewayName 网关名称
     * @param gatewayId 网关id
     * @return 更新结果
     */
    public int updateGatewayNameByGatewayId(@Param("gatewayName") String gatewayName, @Param("gatewayId") String gatewayId);
}
