package com.ruoyi.iot.edge;


import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.TransportProtocol;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.types.DataTypes;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.ITransportProtocolService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@Slf4j
@Component
public class EdgeAdapterManager {

    /**
     * 已注册的驱动工厂：protocolId -> (factory, pluginId)。
     * 由 PluginBootstrap 在插件加载后注册。
     */
    private record RegisteredDriver(EdgeDriverFactory factory, String pluginId) {}

    private final Map<String, RegisteredDriver> drivers = new ConcurrentHashMap<>();

    private final Map<String, EdgeAdapter> protocolAdapterMap = new ConcurrentHashMap<>();

    private final ITransportProtocolService protocolService;

    private final IEdgeDataPointService edgeDataPointService;

    private final EdgeRuntimeContext runtimeContext;


    public EdgeAdapterManager(ITransportProtocolService protocolService,
                              IEdgeDataPointService edgeDataPointService,
                              EdgeRuntimeContext runtimeContext) {
        this.protocolService = protocolService;
        this.edgeDataPointService = edgeDataPointService;
        this.runtimeContext = runtimeContext;
    }

    /**
     * 注册一个由插件提供的驱动工厂。
     *
     * @param factory  驱动工厂
     * @param pluginId 所属 pf4j 插件 id（卸载时用于反向清理适配器）
     */
    public void registerFactory(EdgeDriverFactory factory, String pluginId) {
        drivers.put(factory.getProtocolId(), new RegisteredDriver(factory, pluginId));
        log.info("注册边缘驱动工厂: {} ({}) 来自插件 {}", factory.getProtocolId(), factory.getProtocolName(), pluginId);
    }

    public void unregisterFactory(String protocolId) {
        drivers.remove(protocolId);
        log.info("注销边缘驱动工厂: {}", protocolId);
    }

    /**
     * 卸载插件前调用：禁用并移除所有由该插件创建的适配器，释放连接与定时任务。
     */
    public void disableByPlugin(String pluginId) {
        Set<String> affectedProtocols = drivers.values().stream()
                .filter(d -> pluginId.equals(d.pluginId()))
                .map(d -> d.factory().getProtocolId())
                .collect(Collectors.toSet());
        if (affectedProtocols.isEmpty()) {
            return;
        }
        protocolAdapterMap.entrySet().removeIf(e -> {
            EdgeAdapter adapter = e.getValue();
            if (!affectedProtocols.contains(adapter.getProtocolId())) {
                return false;
            }
            if (adapter.isConnected()) {
                edgeDataPointService.updateValueBatchById(List.copyOf(adapter.getDataPointMap().values()));
            }
            adapter.disable();
            return true;
        });
    }

    /**
     * 注销由指定插件提供的所有驱动工厂（卸载插件时调用，须在 {@link #disableByPlugin} 之后）。
     */
    public void unregisterByPlugin(String pluginId) {
        drivers.values().removeIf(d -> pluginId.equals(d.pluginId()));
    }

    public DataPoint getDataPointValue(String edgeId, String pointId) {
        EdgeAdapter edgeAdapter = getEdgeAdapter(edgeId);
        if (edgeAdapter == null) {
            return null;
        }
        DataPoint dataPoint = edgeAdapter.getDataPointMap().get(pointId);
        // 返回快照，避免调用方误改内部缓存状态
        return dataPoint == null ? null : dataPoint.clone();
    }


    public DataWriteResult writeDataPoint(String edgeId, String pointId, Object value) {
        EdgeAdapter edgeAdapter = getEdgeAdapter(edgeId);

        if (edgeAdapter == null) {
            throw new RuntimeException("边缘网关未开启！");
        }

        if (!edgeAdapter.isConnected()) {
            throw new RuntimeException("边缘网关已经离线！");
        }


        return edgeAdapter.writeDataPoint(pointId, value);
    }

    public EdgeAdapter getEdgeAdapter(String edgeId) {
        return protocolAdapterMap.get(edgeId);
    }

    /**
     * 返回当前所有已注册的适配器（只读视图）。
     */
    public Collection<EdgeAdapter> getAdapters() {
        return protocolAdapterMap.values();
    }

    public EdgeAdapter createAndInitialize(EdgeDevice edgeDevice) {

        // computeIfAbsent 保证同一网关并发初始化时只创建一个适配器，避免重复建连与句柄泄漏
        return protocolAdapterMap.computeIfAbsent(edgeDevice.getId(), id -> {
            TransportProtocol protocol = protocolService.selectTransportProtocolById(edgeDevice.getProtocolId());
            if (protocol == null) {
                throw new IllegalArgumentException("边缘网关 " + id + " 的协议不存在：" + edgeDevice.getProtocolId());
            }

            RegisteredDriver registered = drivers.get(protocol.getId());
            if (registered == null) {
                throw new IllegalArgumentException("不支持的协议类型：" + protocol.getId() + "（未加载对应驱动插件）");
            }
            EdgeDriverFactory factory = registered.factory();

            List<EdgeDataPoint> edgeDataPoints = edgeDataPointService.selectEdgeDataPointListByEdgeId(id);
            Map<String, DataPoint> dataPointMap = new LinkedHashMap<>();
            for (EdgeDataPoint point : edgeDataPoints) {
                Supplier<DataType> supplier = DataTypes.lookup(point.getType());
                if (supplier == null) {
                    log.warn("边缘网关 {} 的点位 {} 数据类型 {} 未注册，已跳过", id, point.getId(), point.getType());
                    continue;
                }
                DataType dataType = supplier.get();
                dataPointMap.put(point.getId(), DataPoint.builder()
                        .id(point.getId())
                        .name(point.getName())
                        .type(dataType)
                        .config(point.getConfig())
                        .build());
            }

            EdgeAdapter edgeAdapter = factory.createAdapter();
            edgeAdapter.setRuntimeContext(runtimeContext);
            edgeAdapter.setProtocolId(protocol.getId());
            edgeAdapter.setProtocolName(protocol.getName());
            edgeAdapter.setEdgeDeviceId(edgeDevice.getId());
            edgeAdapter.setEdgeDeviceName(edgeDevice.getName());
            edgeAdapter.getDataPointMap().putAll(dataPointMap);
            edgeAdapter.init(edgeDevice);
            return edgeAdapter;
        });
    }

    public void disable(String edgeId) {
        EdgeAdapter edgeAdapter = protocolAdapterMap.remove(edgeId);
        if (edgeAdapter != null) {
            if (edgeAdapter.isConnected()) {
                edgeDataPointService.updateValueBatchById(List.copyOf(edgeAdapter.getDataPointMap().values()));
            }
            edgeAdapter.disable();
        }
    }


}
