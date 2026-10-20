package com.ruoyi.iot.json;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;

import com.ruoyi.iot.api.DeviceMessageCodec;
import org.pf4j.Extension;
import org.pf4j.Plugin;
import org.pf4j.PluginWrapper;


public class DefaultDeviceMessageCodecPlugin extends Plugin {

    public DefaultDeviceMessageCodecPlugin(PluginWrapper wrapper) {
        super(wrapper);
    }

    @Override
    public void start() {
        System.out.println("DefaultDeviceMessageCodecPlugin.start()");
    }

    @Override
    public void stop() {
        System.out.println("DefaultDeviceMessageCodecPlugin.stop()");
    }


    @Extension
    public static class DefaultDeviceMessageCodec implements DeviceMessageCodec {

        @Override
        public String getId() {
            return "DefaultCodec";
        }

        @Override
        public JSONObject decode(String deviceId, byte[] payload) {
            return JSON.parseObject(payload);
        }

        @Override
        public byte[] encode(JSONObject state) {
            return JSON.toJSONBytes(state);
        }


    }


}
