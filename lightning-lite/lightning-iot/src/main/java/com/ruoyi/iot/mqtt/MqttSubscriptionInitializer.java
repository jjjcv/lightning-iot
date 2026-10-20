package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.datatypes.MqttQos;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "mqtt.enabled", havingValue = "true", matchIfMissing = true)
public class MqttSubscriptionInitializer {

    private final SubscriptionRegistry registry;
    private final MqttProperties mqttProperties;

    @PostConstruct
    public void init() {
        registry.register(
                mqttProperties.getTopicPattern(),
                MqttQos.fromCode(mqttProperties.getQos())
        );
    }
}
