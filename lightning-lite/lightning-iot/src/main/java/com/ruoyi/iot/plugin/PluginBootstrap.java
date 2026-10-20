package com.ruoyi.iot.plugin;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.iot.api.DeviceMessageCodec;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import com.ruoyi.iot.mqtt.codec.DeviceMessageCodecManager;
import jakarta.annotation.PreDestroy;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.NonNull;
import org.pf4j.PluginManager;
import org.pf4j.PluginWrapper;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * PF4J plugin startup entry.
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
@ConditionalOnProperty(name = "plugin.enabled", havingValue = "true")
public class PluginBootstrap implements CommandLineRunner {

    private final PluginManager pluginManager;
    private final DeviceMessageCodecManager codecManager;
    private final EdgeAdapterManager edgeAdapterManager;
    public PluginBootstrap(PluginManager pluginManager, DeviceMessageCodecManager codecManager,
                           EdgeAdapterManager edgeAdapterManager) {
        this.pluginManager = pluginManager;
        this.codecManager = codecManager;
        this.edgeAdapterManager = edgeAdapterManager;
    }

    @Override
    public void run(String @NonNull ... args) {
        printLogo();
        pluginManager.loadPlugins();

        // 启动所有已加载插件
        List<String> pluginIds = pluginManager.getPlugins().stream()
                .map(PluginWrapper::getPluginId).toList();
        for (String pluginId : pluginIds) {
            try {
                pluginManager.startPlugin(pluginId);
            } catch (Exception e) {
                log.error("启动插件 {} 失败", pluginId, e);
            }
        }
        List<DeviceMessageCodec> deviceMessageCodecs = pluginManager.getExtensions(DeviceMessageCodec.class);

        for (DeviceMessageCodec codec : deviceMessageCodecs) {
            codecManager.register(codec);
            log.info("加载编解码器: {}", codec.getClass().getName());
        }

        List<EdgeDriverFactory> pluginManagerExtensions = pluginManager.getExtensions(EdgeDriverFactory.class);

        for (EdgeDriverFactory factory : pluginManagerExtensions) {
            edgeAdapterManager.registerFactory(factory, factory.getProtocolId());
            log.info("加载边缘驱动: {} ({}) 来自插件 {}", factory.getProtocolId(), factory.getProtocolName(), factory.getProtocolId());
        }

    }

    private static void printLogo() {
        System.out.println(StringUtils.repeat("#", 40));
        System.out.println(StringUtils.center("PF4J", 40));
        System.out.println(StringUtils.repeat("#", 40));
    }

    @PreDestroy
    public void destroy() {
        pluginManager.stopPlugins();
    }

}
