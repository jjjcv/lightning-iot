package com.ruoyi.iot.plugin.knx;

import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeDriverFactory;
import org.pf4j.Extension;
import org.pf4j.Plugin;

/** Calimero KNXnet/IP 边缘驱动插件入口。 */
public class KnxEdgeDriverPlugin extends Plugin {

    @Extension
    public static class KnxDriverFactory implements EdgeDriverFactory {

        @Override
        public String getProtocolId() {
            return "knx";
        }

        @Override
        public String getProtocolName() {
            return "KNXnet/IP (Calimero)";
        }

        @Override
        public EdgeAdapter createAdapter() {
            return new KnxEdgeAdapter();
        }
    }
}
