package com.ruoyi.iot.plugin.plc4x;

import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import org.pf4j.Extension;
import org.pf4j.Plugin;
import org.pf4j.PluginWrapper;

public class Plc4xEdgeDriverPlugin extends Plugin {

    public Plc4xEdgeDriverPlugin(PluginWrapper wrapper) {
        super(wrapper);
    }

    @Override
    public void start() {
        System.out.println("Plc4xEdgeDriverPlugin.start()");
    }

    @Override
    public void stop() {
        System.out.println("Plc4xEdgeDriverPlugin.stop()");
    }

    @Extension
    public static class Plc4xDriverFactory implements EdgeDriverFactory {

        @Override
        public String getProtocolId() {
            return "plc4x";
        }

        @Override
        public String getProtocolName() {
            return "Apache PLC4X";
        }

        @Override
        public EdgeAdapter createAdapter() {
            return new Plc4xEdgeAdapter();
        }
    }
}
