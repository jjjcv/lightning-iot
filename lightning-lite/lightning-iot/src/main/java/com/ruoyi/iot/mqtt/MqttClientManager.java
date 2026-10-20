package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.mqtt5.Mqtt5AsyncClient;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "mqtt.enabled", havingValue = "true", matchIfMissing = true)
public class MqttClientManager {

    private final Mqtt5AsyncClient client;
    private final SubscriptionRegistry registry;

    @PostConstruct
    public void start() {
        listenState();
        connect();
    }

    @PreDestroy
    public void shutdown() {
        client.disconnect();
    }

    private void connect() {
        client.connectWith()
                .cleanStart(false)
                .keepAlive(30)
                .send()
                .whenComplete((ack, ex) -> {
                    if (ex != null) {
                        log.error("MQTT connect failed", ex);
                        return;
                    }
                    log.info("MQTT connected");
                    registry.resubscribe(client); // ⭐ 统一恢复订阅
                });
    }

    private void listenState() {
//        client.getState().subscribe(state -> {
//            log.info("MQTT state changed: {}", state);
//        });
    }
}
