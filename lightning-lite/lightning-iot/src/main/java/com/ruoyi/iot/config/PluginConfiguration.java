package com.ruoyi.iot.config;

import com.ruoyi.iot.plugin.IotPluginManager;
import org.pf4j.RuntimeMode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Path;
import java.util.Locale;


@Configuration
public class PluginConfiguration {

    @Bean
    public IotPluginManager pluginManager(@Value("${plugin.mode:dev}") String mode) {
//        Path path = Path.of("./lightning-plugins");
        Path path = Path.of("./plugins");
        RuntimeMode runtimeMode = RuntimeMode.byName(mode);
        return new IotPluginManager(runtimeMode, path);
    }


}
