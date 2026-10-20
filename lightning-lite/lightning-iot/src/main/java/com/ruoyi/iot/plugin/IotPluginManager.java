package com.ruoyi.iot.plugin;

import org.pf4j.*;

import java.nio.file.Path;

public class IotPluginManager extends DefaultPluginManager {

    private final RuntimeMode runtimeMode;

    public IotPluginManager (RuntimeMode runtimeMode, Path... pluginsRoots) {
        super(pluginsRoots);
        this.runtimeMode = runtimeMode;
    }



    @Override
    public RuntimeMode getRuntimeMode() {
        return this.runtimeMode;
    }

    @Override
    protected PluginLoader createPluginLoader() {
        return new CompoundPluginLoader()
                .add(new DevelopmentPluginLoader(this) {
                    @Override
                    protected PluginClassLoader createPluginClassLoader(Path pluginPath, PluginDescriptor pluginDescriptor) {
                        return new SharedLoggingPluginClassLoader(IotPluginManager.this, pluginDescriptor, getClass().getClassLoader());
                    }
                }, this::isDevelopment)
                .add(new JarPluginLoader(this) {
                    @Override
                    protected PluginClassLoader createPluginClassLoader(Path pluginPath, PluginDescriptor pluginDescriptor) {
                        return new SharedLoggingPluginClassLoader(IotPluginManager.this, pluginDescriptor, getClass().getClassLoader());
                    }
                }, this::isNotDevelopment)
                .add(new DefaultPluginLoader(this) {
                    @Override
                    protected PluginClassLoader createPluginClassLoader(Path pluginPath, PluginDescriptor pluginDescriptor) {
                        return new SharedLoggingPluginClassLoader(IotPluginManager.this, pluginDescriptor, getClass().getClassLoader());
                    }
                }, this::isNotDevelopment);
    }

    private static class SharedLoggingPluginClassLoader extends PluginClassLoader {

        private SharedLoggingPluginClassLoader(PluginManager pluginManager, PluginDescriptor pluginDescriptor,
                                               ClassLoader parent) {
            super(pluginManager, pluginDescriptor, parent);
        }

        @Override
        protected boolean shouldDelegateToParent(String className) {
            return className.startsWith("org.slf4j.")
                    || className.startsWith("ch.qos.logback.")
                    || super.shouldDelegateToParent(className);
        }
    }
}
