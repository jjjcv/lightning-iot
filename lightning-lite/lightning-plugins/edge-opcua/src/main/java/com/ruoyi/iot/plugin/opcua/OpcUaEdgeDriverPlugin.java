package com.ruoyi.iot.plugin.opcua;

import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import org.pf4j.Extension;
import org.pf4j.Plugin;

/** Eclipse Milo OPC UA 边缘驱动插件入口。 */
public class OpcUaEdgeDriverPlugin extends Plugin {

    @Extension
    public static class OpcUaDriverFactory implements EdgeDriverFactory {

        @Override
        public String getProtocolId() {
            return "opcua";
        }

        @Override
        public String getProtocolName() {
            return "OPC UA (Eclipse Milo)";
        }

        @Override
        public EdgeAdapter createAdapter() {
            return new OpcUaEdgeAdapter();
        }
    }
}
