package com.ruoyi.iot.mqtt.codec;

import com.ruoyi.iot.api.DeviceMessageCodec;
import org.jctools.maps.NonBlockingHashMap;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class DeviceMessageCodecManager {

    private final Map<String, DeviceMessageCodec> codecMap = new NonBlockingHashMap<>();

    public void register(DeviceMessageCodec codec) {
        codecMap.put(codec.getId(), codec);
    }

    public void unregister(String id) {
        codecMap.remove(id);
    }

    public DeviceMessageCodec getCodec(String id) {
        DeviceMessageCodec codec = codecMap.get(id);
        if (codec == null) {
            throw new IllegalStateException("No codec for id: " + id);
        }
        return codec;
    }
}
