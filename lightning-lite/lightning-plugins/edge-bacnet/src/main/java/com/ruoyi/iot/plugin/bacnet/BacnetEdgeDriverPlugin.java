package com.ruoyi.iot.plugin.bacnet;

import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import org.pf4j.Extension;
import org.pf4j.Plugin;

/** BACnet4J BACnet/IP 边缘驱动插件入口。 */
public class BacnetEdgeDriverPlugin extends Plugin {

    @Extension
    public static class BacnetDriverFactory implements EdgeDriverFactory {
        @Override
        public String getProtocolId() {
            return "bacnet";
        }

        @Override
        public String getProtocolName() {
            return "BACnet/IP (BACnet4J)";
        }

        @Override
        public EdgeAdapter createAdapter() {
            return new BacnetEdgeAdapter();
        }
    }
}
