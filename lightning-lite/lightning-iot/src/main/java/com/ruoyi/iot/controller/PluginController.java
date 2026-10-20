package com.ruoyi.iot.controller;

import com.ruoyi.iot.api.DeviceMessageCodec;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import com.ruoyi.iot.mqtt.codec.DeviceMessageCodecManager;
import com.ruoyi.iot.plugin.IotPluginManager;
import lombok.RequiredArgsConstructor;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.nio.file.Path;

@RestController
@RequestMapping("/plugin")
@RequiredArgsConstructor
public class PluginController {

    private final IotPluginManager pluginManager;
    private final DeviceMessageCodecManager codecManager;
    private final EdgeAdapterManager edgeAdapterManager;
    @PostMapping("/upload")
    public Mono<String> upload(@RequestPart("file") FilePart file) {

        // 统一使用 PluginManager 的插件根目录，避免上传目录与加载目录不一致
        Path pluginRoot = pluginManager.getPluginsRoot();
        Path target = pluginRoot.resolve(file.filename());

        return file.transferTo(target)
                .doOnSuccess(v -> {
                    String pluginId = pluginManager.loadPlugin(target);
                    pluginManager.startPlugin(pluginId);

                    pluginManager.getExtensions(DeviceMessageCodec.class, pluginId)
                            .forEach(codecManager::register);

                    pluginManager.getExtensions(EdgeDriverFactory.class, pluginId)
                            .forEach(factory -> edgeAdapterManager.registerFactory(factory, pluginId));
                })
                .thenReturn("OK");
    }

    @DeleteMapping("/{pluginId}")
    public Mono<String> unload(@PathVariable String pluginId) {
        // 先回收该插件创建的适配器并注销其驱动工厂，再卸载插件，避免连接/类加载器泄漏
        edgeAdapterManager.disableByPlugin(pluginId);
        edgeAdapterManager.unregisterByPlugin(pluginId);
        pluginManager.stopPlugin(pluginId);
        pluginManager.unloadPlugin(pluginId);
        return Mono.just("UNLOADED");
    }
}
