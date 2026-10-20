package com.ruoyi.iot.edge;

import java.util.List;
import java.util.Map;

/**
 * 边缘驱动访问核心运行时能力的统一端口。
 *
 * <p>由 core 注入实现，插件通过本接口发布状态与数据事件，并同步注册自动发现的点位，
 * 无需依赖 Spring、数据库或 core 内部事件类。</p>
 */
public interface EdgeRuntimeContext {

    /** 上报网关上线。 */
    void publishOnline(String edgeDeviceId);

    /** 上报网关离线。 */
    void publishOffline(String edgeDeviceId);

    /** 上报点位数据变更（key=pointId）。 */
    void publishDataPoints(String edgeDeviceId, Map<String, DataPoint> changed);

    /**
     * 幂等持久化驱动发现的点位，并返回已存在或本次新建的数据点。
     */
    List<DataPoint> registerDataPoints(
            String edgeDeviceId,
            String protocolId,
            List<DiscoveredDataPoint> points);
}
