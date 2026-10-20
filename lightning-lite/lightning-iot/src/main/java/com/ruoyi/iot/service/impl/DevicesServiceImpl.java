package com.ruoyi.iot.service.impl;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceStatistics;
import com.ruoyi.iot.edge.DataWriteResult;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.mapper.DeviceMapper;
import com.ruoyi.iot.service.IDeviceBindingService;
import com.ruoyi.iot.service.ConnectionStatusStore;
import com.ruoyi.iot.service.IDevicesService;
import com.ruoyi.iot.service.IEdgeDeviceService;
import com.ruoyi.iot.service.IProductsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Arrays;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * 设备Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@Service
public class DevicesServiceImpl implements IDevicesService 
{
    @Autowired
    private DeviceMapper deviceMapper;

    @Autowired
    private TagBindingService tagBindingService;

    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    private IProductsService productsService;

    @Autowired
    private EdgeAdapterManager edgeAdapterManager;

    @Autowired
    private IDeviceBindingService deviceBindingService;

    @Autowired
    private ConnectionStatusStore connectionStatusStore;


    @Override
    public DataWriteResult write(String productId, String deviceId, String telemetryKey, String value){

        DeviceBinding deviceBinding = deviceBindingService.getValue(productId, deviceId, telemetryKey);
        if (deviceBinding != null) {
            return edgeAdapterManager.writeDataPoint(deviceBinding.getGatewayId(), deviceBinding.getEdgePointId(), value);
        }

        DeviceBinding query = new DeviceBinding();
        query.setProductId(productId);
        query.setDeviceId(deviceId);
        query.setTelemetryKey(telemetryKey);
        List<DeviceBinding> deviceBindings = deviceBindingService.selectDeviceBindingList(query);
        if (deviceBindings.isEmpty()) {
            return DataWriteResult.of(false, "未找到设备属性绑定");
        }
        DeviceBinding first = deviceBindings.getFirst();
        return edgeAdapterManager.writeDataPoint(first.getGatewayId(), first.getEdgePointId(), value);
    }

    @Override
    public DataWriteResult write(String deviceId, String telemetryKey, String value){
        DeviceBinding binding = new DeviceBinding();
        binding.setDeviceId(deviceId);
        binding.setTelemetryKey(telemetryKey);
        List<DeviceBinding> deviceBindings = deviceBindingService.selectDeviceBindingList(binding);
        if (deviceBindings.isEmpty()) {
            return DataWriteResult.of(false, "未找到设备属性绑定");
        }
        DeviceBinding first = deviceBindings.getFirst();
        return edgeAdapterManager.writeDataPoint(first.getGatewayId(), first.getEdgePointId(), value);
    }

    @Override
    public int countByProductId(String productId){
        return deviceMapper.countByProductId(productId);
    }

    /**
     * 设备统计：总数、在线、离线、启用、停用
     *
     * @return 设备统计结果
     */
    @Override
    public DeviceStatistics selectDeviceStatistics()
    {
        DeviceStatistics statistics = deviceMapper.selectDeviceStatistics();
        List<Device> allDevices = deviceMapper.selectDeviceList(new Device());
        long online = connectionStatusStore.countOnlineDevices(allDevices.stream().map(Device::getId).toList());
        statistics.setOnline(online);
        statistics.setOffline(Math.max(0, statistics.getTotal() - online));
        Map<String, Long> deviceTypeCount = new HashMap<>();
        for (Map<String, Object> row : deviceMapper.selectDeviceTypeCount())
        {
            String deviceType = (String) row.get("deviceType");
            if (StringUtils.isNotEmpty(deviceType))
            {
                Object count = row.get("count");
                deviceTypeCount.put(deviceType, count == null ? 0L : ((Number) count).longValue());
            }
        }
        statistics.setDeviceTypeCount(deviceTypeCount);
        return statistics;
    }
    /**
     * 查询设备
     * 
     * @param id 设备主键
     * @return 设备
     */
    @Override
    public Device selectDevicesById(String id)
    {
        Device device = deviceMapper.selectDeviceById(id);
        if (device != null) {
            connectionStatusStore.hydrateDevices(List.of(device));
        }
        return device;
    }

    /**
     * 查询设备列表
     * 
     * @param device 设备
     * @return 设备
     */
    @Override
    public List<Device> selectDevicesList(Device device)
    {
        List<Device> devices = deviceMapper.selectDeviceList(device);
        connectionStatusStore.hydrateDevices(devices);
        return devices.stream()
            .filter(item -> StringUtils.isEmpty(device.getLinkStatus()) || Objects.equals(device.getLinkStatus(), item.getLinkStatus()))
            .filter(item -> connectionStatusStore.matchesStatusTime(device.getStatusTime(), item.getStatusTime()))
            .toList();
    }

    /**
     * 新增设备
     * 
     * @param device 设备
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertDevices(Device device)
    {
        device.setCreateTime(DateUtils.getNowDate());
        int rows = deviceMapper.insertDevice(device);
        if (rows > 0) {
            connectionStatusStore.synchronizeDeviceWithGateway(device.getId(), device.getGatewayId());
        }
        if (rows > 0 && device.getTagIds() != null) {
            tagBindingService.replaceTags("device", device.getId(), device.getTagIds());
        }
        return rows;
    }

    /**
     * 导入设备数据
     *
     * @param deviceList 设备数据列表
     * @param isUpdateSupport 是否更新已存在设备
     * @param operName 操作用户
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importDevices(List<Device> deviceList, boolean isUpdateSupport, String operName)
    {
        if (StringUtils.isNull(deviceList) || deviceList.isEmpty())
        {
            throw new ServiceException("导入设备数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (Device device : deviceList)
        {
            try
            {
                if (StringUtils.isEmpty(device.getId()))
                {
                    device.setId(IdUtil.getSnowflakeNextIdStr());
                    device.setCreateBy(operName);
                    insertDevices(device);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、设备 " + device.getName() + " 导入成功");
                    continue;
                }

                Device oldDevice = deviceMapper.selectDeviceById(device.getId());
                if (StringUtils.isNull(oldDevice))
                {
                    device.setCreateBy(operName);
                    insertDevices(device);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、设备 " + device.getName() + " 导入成功");
                }
                else if (isUpdateSupport)
                {
                    device.setUpdateBy(operName);
                    updateDevices(device);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、设备 " + device.getName() + " 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、设备 " + device.getName() + " 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                failureMsg.append("<br/>" + failureNum + "、设备 " + device.getName() + " 导入失败：" + e.getMessage());
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }

    /**
     * 修改设备
     *
     * @param device 设备
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateDevices(Device device)
    {
        Device existing = deviceMapper.selectDeviceById(device.getId());
        if (existing == null)
        {
            throw new ServiceException("设备不存在：" + device.getId());
        }
        device.setUpdateTime(DateUtils.getNowDate());
        int rows = deviceMapper.updateDevice(device);
        if (rows > 0 && device.getGatewayId() != null) {
            connectionStatusStore.synchronizeDeviceWithGateway(device.getId(), device.getGatewayId());
        }
        if (rows > 0 && device.getTagIds() != null) {
            tagBindingService.replaceTags("device", device.getId(), device.getTagIds());
        }
        return rows;
    }

    /**
     * 批量删除设备
     * 
     * @param ids 需要删除的设备主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteDevicesByIds(String[] ids)
    {
        for (String id : Arrays.stream(ids).distinct().sorted().toList()) {
            tagBindingService.removeObjectTags("device", id);
            deviceBindingService.deleteByDeviceId(id);
            connectionStatusStore.removeDeviceStatus(id);
        }
        return deviceMapper.deleteDevicesByIds(ids);
    }

    /**
     * 删除设备信息
     * 
     * @param id 设备主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteDevicesById(String id)
    {
        tagBindingService.removeObjectTags("device", id);
        deviceBindingService.deleteByDeviceId(id);
        connectionStatusStore.removeDeviceStatus(id);
        return deviceMapper.deleteDeviceById(id);
    }
}
