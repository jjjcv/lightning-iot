package com.ruoyi.iot.cache;

import com.ruoyi.iot.scene.DeviceState;
import org.jctools.maps.NonBlockingHashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 设备状态缓存
 * 以DeviceState形式保存设备最新状态，key为 deviceState:productId:deviceId
 * 参考 DeviceBindingServiceImpl.putValue：内存缓存 + Redis 双写，读取时内存未命中回源 Redis
 */
@Component
public class DeviceStateCache {

    private static final String KEY_PREFIX = "deviceState:";

    private final Map<String, DeviceState> cache = new NonBlockingHashMap<>();

    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 保存设备最新状态（内存 + Redis 双写）
     */
    public void put(DeviceState deviceState) {
        String key = KEY_PREFIX + deviceState.getProductId() + ":" + deviceState.getDeviceId();
        cache.put(key, deviceState);
        redisTemplate.opsForValue().set(key, deviceState);
    }

    /**
     * 获取设备最新状态（内存未命中回源 Redis）
     */
    public DeviceState get(String productId, String deviceId) {
        String key = KEY_PREFIX + productId + ":" + deviceId;
        if (!cache.containsKey(key)) {
            return (DeviceState) redisTemplate.opsForValue().get(key);
        }
        return cache.get(key);
    }
}
