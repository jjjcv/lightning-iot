package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.datatypes.MqttQos;
import com.hivemq.client.mqtt.mqtt5.Mqtt5AsyncClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Slf4j
@Component
@ConditionalOnProperty(name = "mqtt.enabled", havingValue = "true", matchIfMissing = true)
public class SubscriptionRegistry {

    private final List<Subscription> subs = new CopyOnWriteArrayList<>();
    private final Mqtt5AsyncClient client;

    public SubscriptionRegistry(Mqtt5AsyncClient client) {
        this.client = client;
    }

    public void register(String topic, MqttQos qos) {
        Subscription sub = new Subscription(topic, qos);
        subs.add(sub);

        // 如果 client 已连接，立即订阅
        if (client.getState().isConnected()) {
            client.subscribeWith()
                    .topicFilter(sub.topic())
                    .qos(sub.qos())
                    .send()
                    .whenComplete((ack, ex) -> {
                        if (ex != null) {
                            log.error("订阅失败: {}", sub.topic(), ex);
                        } else {
                            log.info("订阅成功: {}", sub.topic());
                        }
                    });
        }
    }

    public void resubscribe(Mqtt5AsyncClient client) {
        subs.forEach(sub -> client.subscribeWith()
                .topicFilter(sub.topic())
                .qos(sub.qos())
                .send()
                .whenComplete((ack, ex) -> {
                    if (ex != null) {
                        log.error("重订阅失败: {}", sub.topic(), ex);
                    } else {
                        log.info("重订阅成功: {}", sub.topic());
                    }
                }));
    }

    public record Subscription(String topic, MqttQos qos) {
    }
}