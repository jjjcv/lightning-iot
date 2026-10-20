package com.ruoyi.iot.service;

import java.util.List;
import java.util.Map;

import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.DeviceBinding;
import org.apache.ibatis.annotations.Param;
import org.jctools.maps.NonBlockingHashMap;
import org.springframework.cache.annotation.Cacheable;

/**
 * 设备属性模板Service接口
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
public interface IDeviceBindingService 
{
    public Map<String, DeviceBinding> DEVICE_BINDING_ID_TO_VALUE = new NonBlockingHashMap<>();
    public Map<String, DeviceBinding> DEVICE_BINDING_TO_VALUE = new NonBlockingHashMap<>();

    void updateValueBatchById(List<DeviceBinding> deviceBindingList);


    void putValue(DeviceBinding deviceBinding);

    DeviceBinding getValue(String id);

    DeviceBinding getValue(String productId, String deviceId, String telemetryId);

    DeviceBinding getKeyValue(String key);

    /**
     * 查询设备属性模板
     * 
     * @param id 设备属性模板主键
     * @return 设备属性模板
     */
    public DeviceBinding selectDeviceBindingById(String id);

    /**
     * 查询设备属性模板列表
     * 
     * @param deviceBinding 设备属性模板
     * @return 设备属性模板集合
     */
    public List<DeviceBinding> selectDeviceBindingList(DeviceBinding deviceBinding);

    public List<DeviceBinding> selectDeviceBindingExportList(Device device);

    List<DeviceBinding> selectAllByEdgePointId(String edgePointId);

    @Cacheable(key = "gatewayId + #gatewayId")
    List<DeviceBinding> selectAllByGatewayId(String gatewayId);

    List<DeviceBinding> selectAllByProductId(String productId);

    @Cacheable(key = "'deviceId:' + #deviceId")
    List<DeviceBinding> selectAllByDeviceId(String deviceId);

    /**
     * 新增设备属性模板
     * 
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    public int insertDeviceBinding(DeviceBinding deviceBinding);

    /**
     * 导入设备属性模板数据
     *
     * @param deviceBindingList 设备属性模板数据列表
     * @param isUpdateSupport 是否更新已存在的数据
     * @param operName 操作用户
     * @return 导入结果
     */
    public String importDeviceBinding(List<DeviceBinding> deviceBindingList, boolean isUpdateSupport, String operName);

    /**
     * 修改设备属性模板
     * 
     * @param deviceBinding 设备属性模板
     * @return 结果
     */
    public int updateDeviceBinding(DeviceBinding deviceBinding);

    /**
     * 批量删除设备属性模板
     * 
     * @param ids 需要删除的设备属性模板主键集合
     * @return 结果
     */
    public int deleteDeviceBindingByIds(String[] ids);

    /**
     * 删除设备属性模板信息
     * 
     * @param id 设备属性模板主键
     * @return 结果
     */
    public int deleteDeviceBindingById(String id);

    int deleteByDeviceId(@Param("deviceId") String deviceId);

    int updateEdgePointNameByEdgePointId(String edgePointName, String edgePointId);

    int updateGatewayNameByGatewayId(String gatewayName, String gatewayId);
}
