package com.ruoyi.iot.edge;


import lombok.Getter;
import lombok.Setter;
import reactor.core.scheduler.Scheduler;
import reactor.core.scheduler.Schedulers;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

@Getter
public abstract class EdgeAdapter {

    /**
     * 用于执行阻塞 I/O（如 Modbus 读取）的虚拟线程调度器，所有适配器实例共享。
     */
    public static final Scheduler virtualThreadScheduler = Schedulers.fromExecutorService(
            Executors.newVirtualThreadPerTaskExecutor()
    );

    /**
     * 用于驱动定时刷新/检测循环的调度器，所有适配器实例共享。
     */
    public static final Scheduler edgeScheduler = Schedulers.newBoundedElastic(Runtime.getRuntime().availableProcessors() * 10, 512, "edgeScheduler");

    private final AtomicBoolean enabledStatus = new AtomicBoolean(false);
    private final AtomicBoolean onlineStatus = new AtomicBoolean(false);

    @Setter
    private String protocolId;

    @Setter
    private String protocolName;

    @Setter
    private String edgeDeviceId;

    @Setter
    private String edgeDeviceName;

    @Setter
    private Map<String, DataPoint> dataPointMap = new ConcurrentHashMap<>();

    /** 核心应用在初始化时注入的统一运行时上下文。 */
    @Setter
    private EdgeRuntimeContext runtimeContext;

    /**
     * 将驱动发现的点位交给核心持久化，并立即合并到当前适配器缓存。
     */
    protected List<DataPoint> registerDiscoveredDataPoints(List<DiscoveredDataPoint> points) {
        if (runtimeContext == null || points == null || points.isEmpty()) {
            return List.of();
        }
        List<DataPoint> registered = runtimeContext.registerDataPoints(
                edgeDeviceId, protocolId, List.copyOf(points));
        if (registered != null) {
            registered.forEach(point -> dataPointMap.put(point.getId(), point));
            return List.copyOf(registered);
        }
        return List.of();
    }

    public boolean isEnabled() {
        return enabledStatus.get();
    }

    public boolean isOnline() {
        return onlineStatus.get();
    }

    public void setEnabledStatus(boolean enabled) {
        enabledStatus.set(enabled);
    }

    public void setOnlineStatus(boolean online) {
        onlineStatus.set(online);
    }

    public abstract void enable();

    public abstract void disable();

    public abstract void online();

    public abstract void offline();

    public abstract void init(EdgeDeviceConfig edgeDevice);

    public abstract boolean connect();

    public abstract boolean disconnect();

    public abstract boolean isConnected();

    public abstract DataPoint readDataPoint(DataPoint point);

    public abstract List<DataPoint> readDataPoints(List<DataPoint> points);

    public abstract DataWriteResult writeDataPoint(String pointId, Object value);

    public abstract Map<String, DataWriteResult> writeDataPoints(Map<String, Object> pointValues);

    public abstract void startDataRefresh();

    public abstract void stopDataRefresh();

    public abstract void startDetectionLoop();

    public abstract void stopDetectionLoop();
}
