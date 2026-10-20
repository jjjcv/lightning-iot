package com.ruoyi.iot.edge;

import org.pf4j.ExtensionPoint;

/**
 * 边缘协议驱动工厂，作为 pf4j 扩展点。
 *
 * <p>每个协议（如 modbus、opc-ua）提供一个实现，由 pf4j 发现并注册到 {@link EdgeAdapterManager}。
 * 与 {@link com.ruoyi.iot.api.DeviceMessageCodec} 不同：适配器有状态且每网关一个实例，
 * 因此扩展点是「工厂」而非适配器本身——管理器在初始化每个网关时调用 {@link #createAdapter()}
 * 获取专属实例。
 *
 * <p>{@link #getProtocolId()} 返回值须与 transport_protocol.id 一致，用于网关按协议匹配驱动。
 */
public interface EdgeDriverFactory extends ExtensionPoint {

    /** 协议 id，须与 transport_protocol.id 一致，如 "modbus" */
    String getProtocolId();

    /** 协议展示名 */
    String getProtocolName();

    /** 创建一个全新的、尚未 init 的适配器实例（每网关调一次） */
    EdgeAdapter createAdapter();
}
