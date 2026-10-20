package com.ruoyi.iot.api;


import com.alibaba.fastjson2.JSONObject;
import org.pf4j.ExtensionPoint;

public interface DeviceMessageCodec extends ExtensionPoint {

    /** 支持的产品 id */
    String getId();

    /** 解析设备上报报文 */
    JSONObject decode(String deviceId, byte[] payload);

    /** 组装 MQTT 下行报文 */
    byte[] encode(JSONObject state);
}
