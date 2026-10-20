package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.MqttGlobalPublishFilter;
import com.hivemq.client.mqtt.mqtt5.Mqtt5AsyncClient;
import com.ruoyi.iot.dispatcher.TopicDispatcher;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "mqtt.enabled", havingValue = "true", matchIfMissing = true)
public class MqttMessageListener {

    private final Mqtt5AsyncClient client;
    private final TopicDispatcher dispatcher;

    @PostConstruct
    public void listen() {

        client.publishes(MqttGlobalPublishFilter.ALL, publish -> {

            try {
                publish.getPayloadAsBytes();

                publish.getTopic();
                String topic = publish.getTopic().toString();

                byte[] payload = publish.getPayloadAsBytes();

                if (topic == null) {
                    log.warn("Invalid mqtt message, topic={}, payload={}",
                            null, payload.length);
                    return;
                }

                dispatcher.dispatch(topic, payload);

            } catch (Throwable e) {
                // ⚠️ 一定要 catch Throwable，防止 Error 直接打死线程
                log.error("MQTT message handle failed", e);
            }
        });
    }
}