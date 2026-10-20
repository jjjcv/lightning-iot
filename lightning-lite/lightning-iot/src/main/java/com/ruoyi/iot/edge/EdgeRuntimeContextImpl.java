package com.ruoyi.iot.edge;

import cn.hutool.core.lang.Snowflake;
import cn.hutool.core.util.IdUtil;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.event.DeviceBindingEvent;
import com.ruoyi.iot.event.EdgeStatusEvent;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.types.DataTypes;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.utils.EventPublisherHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Supplier;

/** 核心应用提供给边缘驱动的运行时能力实现。 */
@Slf4j
@Component
public class EdgeRuntimeContextImpl implements EdgeRuntimeContext {

    private static final Snowflake POINT_ID_GENERATOR = IdUtil.getSnowflake(1, 1);

    private final IEdgeDataPointService edgeDataPointService;

    public EdgeRuntimeContextImpl(IEdgeDataPointService edgeDataPointService) {
        this.edgeDataPointService = edgeDataPointService;
    }

    @Override
    public void publishOnline(String edgeDeviceId) {
        EventPublisherHolder.publishEvent(EdgeStatusEvent.of(true, edgeDeviceId));
    }

    @Override
    public void publishOffline(String edgeDeviceId) {
        EventPublisherHolder.publishEvent(EdgeStatusEvent.of(false, edgeDeviceId));
    }

    @Override
    public void publishDataPoints(String edgeDeviceId, Map<String, DataPoint> changed) {
        EventPublisherHolder.publishEvent(DeviceBindingEvent.of(changed, edgeDeviceId));
    }

    @Override
    public synchronized List<DataPoint> registerDataPoints(
            String edgeDeviceId,
            String protocolId,
            List<DiscoveredDataPoint> discoveredPoints) {
        if (discoveredPoints == null || discoveredPoints.isEmpty()) {
            return List.of();
        }

        Map<String, EdgeDataPoint> existingByKey = new HashMap<>();
        for (EdgeDataPoint existing : edgeDataPointService.selectEdgeDataPointListByEdgeId(edgeDeviceId)) {
            String key = protocolPointKey(existing.getConfig());
            if (key != null && !key.isBlank()) {
                existingByKey.putIfAbsent(key, existing);
            }
        }

        List<DataPoint> registered = new ArrayList<>();
        int createdCount = 0;
        for (DiscoveredDataPoint discovered : discoveredPoints) {
            if (discovered == null || discovered.key() == null || discovered.key().isBlank()) {
                continue;
            }
            String key = discovered.key().trim();
            EdgeDataPoint existing = existingByKey.get(key);
            if (existing != null) {
                toDataPoint(existing).ifPresent(registered::add);
                continue;
            }
            if (DataTypes.lookup(discovered.type()) == null) {
                log.warn("边缘网关 {} 自动发现点位 {} 的数据类型 {} 未注册，已跳过",
                        edgeDeviceId, key, discovered.type());
                continue;
            }

            EdgeDataPoint entity = new EdgeDataPoint();
            entity.setId(POINT_ID_GENERATOR.nextIdStr());
            entity.setName(limit(discovered.name(), 256));
            entity.setProtocolId(protocolId);
            entity.setGatewayId(edgeDeviceId);
            entity.setType(discovered.type());
            entity.setOperationTpye(discovered.operationType());
            entity.setConfig(discovered.config());
            entity.setCreateBy("system");
            try {
                edgeDataPointService.insertEdgeDataPoint(entity);
                existingByKey.put(key, entity);
                createdCount++;
                toDataPoint(entity).ifPresent(registered::add);
            } catch (Exception e) {
                log.error("边缘网关 {} 自动创建点位 {} 失败", edgeDeviceId, key, e);
            }
        }
        if (createdCount > 0) {
            log.info("边缘网关 {} 自动创建 {} 个数据点位", edgeDeviceId, createdCount);
        }
        return registered;
    }

    private static Optional<DataPoint> toDataPoint(EdgeDataPoint point) {
        Supplier<DataType> supplier = DataTypes.lookup(point.getType());
        if (supplier == null) {
            log.warn("边缘点位 {} 的数据类型 {} 未注册，已跳过", point.getId(), point.getType());
            return Optional.empty();
        }
        return Optional.of(DataPoint.builder()
                .id(point.getId())
                .name(point.getName())
                .type(supplier.get())
                .config(point.getConfig())
                .build());
    }

    private static String protocolPointKey(String config) {
        if (config == null || config.isBlank()) {
            return null;
        }
        try {
            JSONObject object = JSON.parseObject(config);
            String key = object.getString("node_id");
            if (key == null || key.isBlank()) {
                key = object.getString("nodeId");
            }
            if (key == null || key.isBlank()) {
                key = object.getString("address");
            }
            if (key != null && !key.isBlank()) {
                return key.trim();
            }

            String deviceInstance = object.getString("deviceInstance");
            String objectType = object.getString("objectType");
            String objectInstance = object.getString("objectInstance");
            if (deviceInstance != null && !deviceInstance.isBlank()
                    && objectType != null && !objectType.isBlank()
                    && objectInstance != null && !objectInstance.isBlank()) {
                return deviceInstance.trim() + "/" + objectType.trim() + "/"
                        + objectInstance.trim() + "/presentValue";
            }
            return null;
        } catch (Exception ignored) {
            return null;
        }
    }

    private static String limit(String value, int maxLength) {
        String actual = value == null || value.isBlank() ? "未命名点位" : value;
        return actual.length() <= maxLength ? actual : actual.substring(0, maxLength);
    }
}
