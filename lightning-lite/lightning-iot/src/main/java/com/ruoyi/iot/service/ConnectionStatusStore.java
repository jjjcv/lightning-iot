package com.ruoyi.iot.service;

import com.ruoyi.iot.domain.Device;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.mapper.DeviceMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/** Redis-backed gateway and device connection status. */
@Component
@Slf4j
@SuppressWarnings({"rawtypes", "unchecked"})
public class ConnectionStatusStore {
    public static final String EDGE_STATUS_KEY = "iot:connection-status:edge";
    public static final String EDGE_ONLINE_KEY = "iot:connection-status:edge:online";
    public static final String DEVICE_STATUS_KEY = "iot:connection-status:device";
    public static final String DEVICE_ONLINE_KEY = "iot:connection-status:device:online";
    public static final String ONLINE = "online";
    public static final String OFFLINE = "offline";

    private final DeviceMapper deviceMapper;
    private final RedisTemplate redisTemplate;

    public ConnectionStatusStore(DeviceMapper deviceMapper, RedisTemplate redisTemplate) {
        this.deviceMapper = deviceMapper;
        this.redisTemplate = redisTemplate;
    }

    public void updateGatewayStatus(String edgeDeviceId, String status) {
        if (isBlank(edgeDeviceId) || !isKnownStatus(status)) return;
        Snapshot current = getSnapshot(EDGE_STATUS_KEY, edgeDeviceId);
        if (current != null && Objects.equals(current.getStatus(), status)) return;
        Date changedAt = new Date();
        saveSnapshot(EDGE_STATUS_KEY, EDGE_ONLINE_KEY, edgeDeviceId, new Snapshot(status, changedAt));
        saveSnapshots(DEVICE_STATUS_KEY, DEVICE_ONLINE_KEY, findDeviceIdsByGatewayId(edgeDeviceId), status, changedAt);
    }

    /**
     * 管理端启停网关时仅更新网关自身状态；关联设备由驱动实际发布的状态事件同步，
     * 避免一次启停触发全量设备缓存写入。
     */
    public void markGatewayOffline(String edgeDeviceId) {
        if (isBlank(edgeDeviceId)) return;
        Date changedAt = new Date();
        saveSnapshot(EDGE_STATUS_KEY, EDGE_ONLINE_KEY, edgeDeviceId, new Snapshot(OFFLINE, changedAt));
    }

    public void synchronizeDeviceWithGateway(String deviceId, String gatewayId) {
        if (isBlank(deviceId)) return;
        if (isBlank(gatewayId)) {
            removeDeviceStatus(deviceId);
            return;
        }
        Snapshot gatewaySnapshot = getSnapshot(EDGE_STATUS_KEY, gatewayId);
        if (gatewaySnapshot == null) {
            removeDeviceStatus(deviceId);
            return;
        }
        saveSnapshot(DEVICE_STATUS_KEY, DEVICE_ONLINE_KEY, deviceId,
                new Snapshot(gatewaySnapshot.getStatus(), gatewaySnapshot.getChangedAt()));
    }

    public void removeGatewayStatus(String edgeDeviceId) {
        if (isBlank(edgeDeviceId)) return;
        removeSnapshot(EDGE_STATUS_KEY, EDGE_ONLINE_KEY, edgeDeviceId);
        saveSnapshots(DEVICE_STATUS_KEY, DEVICE_ONLINE_KEY, findDeviceIdsByGatewayId(edgeDeviceId), OFFLINE, new Date());
    }

    public void removeDeviceStatus(String deviceId) { removeSnapshot(DEVICE_STATUS_KEY, DEVICE_ONLINE_KEY, deviceId); }

    public void removeDeviceStatuses(Collection<String> deviceIds) {
        if (deviceIds != null) deviceIds.forEach(this::removeDeviceStatus);
    }

    public void hydrateEdgeDevices(Collection<EdgeDevice> edgeDevices) {
        if (edgeDevices == null || edgeDevices.isEmpty()) return;
        Map<String, Snapshot> snapshots = getSnapshots(EDGE_STATUS_KEY, edgeDevices.stream().map(EdgeDevice::getId).filter(Objects::nonNull).toList());
        edgeDevices.forEach(edgeDevice -> apply(edgeDevice, snapshots.get(edgeDevice.getId())));
    }

    public void hydrateDevices(Collection<Device> devices) {
        if (devices == null || devices.isEmpty()) return;
        Map<String, Snapshot> snapshots = getSnapshots(DEVICE_STATUS_KEY, devices.stream().map(Device::getId).filter(Objects::nonNull).toList());
        devices.forEach(device -> apply(device, snapshots.get(device.getId())));
    }

    public Set<String> getOnlineEdgeDeviceIds() { return getOnlineIds(EDGE_ONLINE_KEY); }
    public Set<String> getOnlineDeviceIds() { return getOnlineIds(DEVICE_ONLINE_KEY); }
    public long countOnlineEdgeDevices(Collection<String> ids) { return countOnline(EDGE_STATUS_KEY, ids); }
    public long countOnlineDevices(Collection<String> ids) { return countOnline(DEVICE_STATUS_KEY, ids); }

    public boolean matchesStatusTime(Date requested, Date changedAt) {
        if (requested == null) return true;
        if (changedAt == null) return false;
        ZoneId zoneId = ZoneId.systemDefault();
        LocalDate requestedDate = requested.toInstant().atZone(zoneId).toLocalDate();
        LocalDate changedDate = changedAt.toInstant().atZone(zoneId).toLocalDate();
        return requestedDate.equals(changedDate);
    }

    private List<String> findDeviceIdsByGatewayId(String edgeDeviceId) {
        try {
            Device query = new Device();
            query.setGatewayId(edgeDeviceId);
            return deviceMapper.selectDeviceList(query).stream().map(Device::getId).filter(Objects::nonNull).toList();
        } catch (Exception e) {
            log.warn("查询网关 {} 的关联设备失败，连接状态仅更新网关", edgeDeviceId, e);
            return List.of();
        }
    }

    private void apply(EdgeDevice device, Snapshot snapshot) {
        device.setLinkStatus(snapshot == null ? OFFLINE : snapshot.getStatus());
        device.setStatusTime(snapshot == null ? null : snapshot.getChangedAt());
    }

    private void apply(Device device, Snapshot snapshot) {
        device.setLinkStatus(snapshot == null ? OFFLINE : snapshot.getStatus());
        device.setStatusTime(snapshot == null ? null : snapshot.getChangedAt());
    }

    private long countOnline(String hashKey, Collection<String> ids) {
        return getSnapshots(hashKey, ids).values().stream().filter(snapshot -> ONLINE.equals(snapshot.getStatus())).count();
    }

    private Set<String> getOnlineIds(String onlineKey) {
        try {
            Set<Object> members = redisTemplate.opsForSet().members(onlineKey);
            if (members == null || members.isEmpty()) return Collections.emptySet();
            Set<String> ids = new LinkedHashSet<>();
            for (Object member : members) if (member != null) ids.add(String.valueOf(member));
            return ids;
        } catch (Exception e) {
            log.warn("读取 Redis 在线状态索引 {} 失败，按全部离线处理", onlineKey, e);
            return Collections.emptySet();
        }
    }

    private Snapshot getSnapshot(String hashKey, String id) {
        try {
            Object value = redisTemplate.opsForHash().get(hashKey, id);
            return value instanceof Snapshot snapshot ? snapshot : null;
        } catch (Exception e) {
            log.warn("读取 Redis 连接状态 {}:{} 失败，按离线处理", hashKey, id, e);
            return null;
        }
    }

    private Map<String, Snapshot> getSnapshots(String hashKey, Collection<String> ids) {
        if (ids == null || ids.isEmpty()) return Collections.emptyMap();
        try {
            List<String> keys = new ArrayList<>(ids);
            List<Object> values = redisTemplate.opsForHash().multiGet(hashKey, new ArrayList<>(keys));
            Map<String, Snapshot> snapshots = new HashMap<>();
            for (int index = 0; index < keys.size(); index++) {
                Object value = values == null || index >= values.size() ? null : values.get(index);
                if (value instanceof Snapshot snapshot) snapshots.put(keys.get(index), snapshot);
            }
            return snapshots;
        } catch (Exception e) {
            log.warn("批量读取 Redis 连接状态 {} 失败，按全部离线处理", hashKey, e);
            return Collections.emptyMap();
        }
    }

    private void saveSnapshots(String hashKey, String onlineKey, Collection<String> ids, String status, Date changedAt) {
        if (ids == null || ids.isEmpty()) return;
        Map<String, Snapshot> snapshots = new HashMap<>();
        for (String id : ids) if (!isBlank(id)) snapshots.put(id, new Snapshot(status, changedAt));
        if (snapshots.isEmpty()) return;
        try {
            redisTemplate.opsForHash().putAll(hashKey, snapshots);
            if (ONLINE.equals(status)) redisTemplate.opsForSet().add(onlineKey, snapshots.keySet().toArray());
            else redisTemplate.opsForSet().remove(onlineKey, snapshots.keySet().toArray());
        } catch (Exception e) {
            log.warn("批量写入 Redis 连接状态 {} 失败，边缘运行继续", hashKey, e);
        }
    }

    private void saveSnapshot(String hashKey, String onlineKey, String id, Snapshot snapshot) {
        try {
            redisTemplate.opsForHash().put(hashKey, id, snapshot);
            if (ONLINE.equals(snapshot.getStatus())) redisTemplate.opsForSet().add(onlineKey, id);
            else redisTemplate.opsForSet().remove(onlineKey, id);
        } catch (Exception e) {
            log.warn("写入 Redis 连接状态 {}:{} 失败，边缘运行继续", hashKey, id, e);
        }
    }

    private void removeSnapshot(String hashKey, String onlineKey, String id) {
        if (isBlank(id)) return;
        try {
            redisTemplate.opsForHash().delete(hashKey, id);
            redisTemplate.opsForSet().remove(onlineKey, id);
        } catch (Exception e) {
            log.warn("删除 Redis 连接状态 {}:{} 失败", hashKey, id, e);
        }
    }

    private boolean isKnownStatus(String status) { return ONLINE.equals(status) || OFFLINE.equals(status); }
    private boolean isBlank(String value) { return value == null || value.isBlank(); }

    public static class Snapshot implements Serializable {
        private static final long serialVersionUID = 1L;
        private String status;
        private Date changedAt;
        public Snapshot() { }
        public Snapshot(String status, Date changedAt) { this.status = status; this.changedAt = changedAt; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public Date getChangedAt() { return changedAt; }
        public void setChangedAt(Date changedAt) { this.changedAt = changedAt; }
    }
}
