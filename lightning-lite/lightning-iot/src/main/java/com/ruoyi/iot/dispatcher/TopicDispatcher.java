package com.ruoyi.iot.dispatcher;

import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.api.DeviceMessageCodec;
import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.event.DeviceStateEvent;
import com.ruoyi.iot.mqtt.codec.DeviceMessageCodecManager;
import com.ruoyi.iot.scene.DeviceState;
import com.ruoyi.iot.service.IProductsService;
import com.ruoyi.iot.utils.EventPublisherHolder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class TopicDispatcher {

    private final DeviceMessageCodecManager codecManager;
    private final IProductsService productsService;

    public void dispatch(String topic, byte[] payload) {

        // /{productId}/{deviceId}/properties/report
        String[] parts = topic.split("/");
        if (parts.length < 4) {
            return;
        }

        String productId = parts[1];
        String deviceId = parts[2];

        Product product = productsService.selectProductsById(productId);

//        if (product == null || product.getId() == null) {
//            log.warn("找不到产品ID为 {} 的产品信息，设备ID为 {}，跳过消息处理", productId, deviceId);
//            return;
//        }

        DeviceMessageCodec codec = codecManager.getCodec(product.getTransportCodecId());
        if (codec == null) {
            log.warn("找不到产品ID为 {} 的编解码器，设备ID为 {}，跳过消息处理", productId, deviceId);
            return;
        }

        JSONObject jsonObject = codec.decode(deviceId, payload);

        DeviceState deviceState = jsonObject.to(DeviceState.class);

        // 👉 进入平台内部
        EventPublisherHolder.publishEvent(DeviceStateEvent.of(deviceState));
    }
}