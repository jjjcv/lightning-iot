package com.ruoyi.iot.plugin.modbus;

import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import org.pf4j.Extension;
import org.pf4j.Plugin;
import org.pf4j.PluginWrapper;

/**
 * Modbus 边缘驱动插件入口。
 */
public class ModbusEdgeDriverPlugin extends Plugin {

    public ModbusEdgeDriverPlugin(PluginWrapper wrapper) {
        super(wrapper);
    }

    @Override
    public void start() {
        System.out.println("ModbusEdgeDriverPlugin.start()");
    }

    @Override
    public void stop() {
        System.out.println("ModbusEdgeDriverPlugin.stop()");
    }


    /**
     * Modbus 协议驱动工厂（pf4j 扩展点）。
     *
     * <p>protocolId 为 "modbus"，须与 transport_protocol.id 一致。
     * {@link #createAdapter()} 获取专属实例。
     */
    @Extension
    public static class ModbusDriverFactory implements EdgeDriverFactory {

        @Override
        public String getProtocolId() {
            return "modbus";
        }

        @Override
        public String getProtocolName() {
            return "Modbus TCP";
        }

        @Override
        public EdgeAdapter createAdapter() {
            return new ModbusEdgeAdapter();
        }
    }


}
