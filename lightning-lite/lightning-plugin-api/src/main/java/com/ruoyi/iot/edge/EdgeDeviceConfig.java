package com.ruoyi.iot.edge;

/**
 * 边缘网关配置的精简视图，供适配器初始化读取。
 *
 * <p>定义在 lightning-plugin-api 中，避免插件编译期依赖 core 的 DB 实体
 * {@code com.ruoyi.iot.domain.EdgeDevice}。core 侧的 {@code EdgeDevice} 实现本接口。
 */
public interface EdgeDeviceConfig {

    String getId();

    String getName();

    String getProtocolId();

    String getConfiguration();
}
