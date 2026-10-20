package com.ruoyi.iot.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.EdgeDeviceStatistics;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.mapper.EdgeDeviceMapper;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.ConnectionStatusStore;
import com.ruoyi.iot.service.IEdgeDeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import com.ruoyi.common.utils.StringUtils;

/**
 * 设备接入网关Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-02-14
 */
@Service
public class EdgeDeviceServiceImpl implements IEdgeDeviceService 
{
    @Autowired
    private EdgeDeviceMapper edgeDeviceMapper;

    @Autowired
    private EdgeAdapterManager edgeAdapterManager;

    @Autowired
    private IEdgeDataPointService edgeDataPointService;

    @Autowired
    private ConnectionStatusStore connectionStatusStore;


    @Override
    public void enableEdgeDevice(String id){
        EdgeDevice edgeDevice = selectEdgeDeviceById(id);

        if (edgeDevice.getStatus().equals("enable")){
            return;
        }

        edgeDevice.setStatus("enable");
        updateEdgeDeviceStatus(id, "enable");
        connectionStatusStore.markGatewayOffline(id);
        // 先创建并启用适配器，失败则回滚状态，避免 DB 标记为启用但实际未运行
        try {
            EdgeAdapter edgeAdapter = edgeAdapterManager.createAndInitialize(edgeDevice);
            edgeAdapter.enable();
        } catch (Exception e) {
            edgeDevice.setStatus("disable");
            updateEdgeDeviceStatus(id, "disable");
            throw e;
        }
    }

    @Override
    public void disableEdgeDevice(String id){
        EdgeDevice edgeDevice = selectEdgeDeviceById(id);

        if (edgeDevice.getStatus().equals("disable")){
            return;
        }

        edgeDevice.setStatus("disable");
        updateEdgeDeviceStatus(id, "disable");
        connectionStatusStore.markGatewayOffline(id);
        edgeAdapterManager.disable(id);
    }

    private void updateEdgeDeviceStatus(String id, String status) {
        EdgeDevice update = new EdgeDevice();
        update.setId(id);
        update.setStatus(status);
        update.setUpdateTime(DateUtils.getNowDate());
        edgeDeviceMapper.updateEdgeDeviceStatus(update);
    }


    /**
     * 设备接入网关统计：总数、在线、离线、启用、停用
     *
     * @return 设备接入网关统计结果
     */
    @Override
    public EdgeDeviceStatistics selectEdgeDeviceStatistics()
    {
        EdgeDeviceStatistics statistics = edgeDeviceMapper.selectEdgeDeviceStatistics();
        List<EdgeDevice> devices = edgeDeviceMapper.selectEdgeDeviceList(new EdgeDevice());
        long online = connectionStatusStore.countOnlineEdgeDevices(devices.stream().map(EdgeDevice::getId).toList());
        statistics.setOnline(online);
        statistics.setOffline(Math.max(0, statistics.getTotal() - online));
        return statistics;
    }


    /**
     * 查询设备接入网关
     * 
     * @param id 设备接入网关主键
     * @return 设备接入网关
     */
    @Override
    public EdgeDevice selectEdgeDeviceById(String id)
    {
        EdgeDevice edgeDevice = edgeDeviceMapper.selectEdgeDeviceById(id);
        if (edgeDevice != null) {
            connectionStatusStore.hydrateEdgeDevices(List.of(edgeDevice));
        }
        return edgeDevice;
    }

    /**
     * 查询设备接入网关列表
     * 
     * @param edgeDevice 设备接入网关
     * @return 设备接入网关
     */
    @Override
    public List<EdgeDevice> selectEdgeDeviceList(EdgeDevice edgeDevice)
    {
        List<EdgeDevice> devices = edgeDeviceMapper.selectEdgeDeviceList(edgeDevice);
        connectionStatusStore.hydrateEdgeDevices(devices);
        return devices.stream()
            .filter(item -> StringUtils.isEmpty(edgeDevice.getLinkStatus()) || Objects.equals(edgeDevice.getLinkStatus(), item.getLinkStatus()))
            .toList();
    }

    /**
     * 新增设备接入网关
     * 
     * @param edgeDevice 设备接入网关
     * @return 结果
     */
    @Override
    public int insertEdgeDevice(EdgeDevice edgeDevice)
    {
        edgeDevice.setCreateTime(DateUtils.getNowDate());
        edgeDevice.setLinkStatus(null);
        edgeDevice.setStatusTime(null);
        int rows = edgeDeviceMapper.insertEdgeDevice(edgeDevice);
        if (rows > 0) {
            connectionStatusStore.removeGatewayStatus(edgeDevice.getId());
        }
        return rows;
    }

    /**
     * 修改设备接入网关
     * 
     * @param edgeDevice 设备接入网关
     * @return 结果
     */
    @Override
    public int updateEdgeDevice(EdgeDevice edgeDevice)
    {
        edgeDevice.setLinkStatus(null);
        edgeDevice.setStatusTime(null);
        edgeDevice.setUpdateTime(DateUtils.getNowDate());
        return edgeDeviceMapper.updateEdgeDevice(edgeDevice);
    }

    /**
     * 批量删除设备接入网关
     * 
     * @param ids 需要删除的设备接入网关主键
     * @return 结果
     */
    @Override
    public int deleteEdgeDeviceByIds(String[] ids)
    {
        for (String id : ids) {
            edgeDataPointService.deleteByGatewayId(id);
            connectionStatusStore.removeGatewayStatus(id);
        }
        return edgeDeviceMapper.deleteEdgeDeviceByIds(ids);
    }

    /**
     * 删除设备接入网关信息
     * 
     * @param id 设备接入网关主键
     * @return 结果
     */
    @Override
    public int deleteEdgeDeviceById(String id)
    {
        edgeDataPointService.deleteByGatewayId(id);
        connectionStatusStore.removeGatewayStatus(id);
        return edgeDeviceMapper.deleteEdgeDeviceById(id);
    }
}
