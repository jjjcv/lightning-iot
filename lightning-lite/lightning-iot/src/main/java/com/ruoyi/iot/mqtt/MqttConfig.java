package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.MqttClient;
import com.hivemq.client.mqtt.mqtt5.Mqtt5AsyncClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class MqttConfig {

    private final MqttProperties mqttProperties;

    public MqttConfig(MqttProperties mqttProperties) {
        this.mqttProperties = mqttProperties;
    }

    @Bean
    @ConditionalOnProperty(name = "mqtt.enabled", havingValue = "true", matchIfMissing = true)
    public Mqtt5AsyncClient mqttClient() {
        log.info("Initializing MQTT client with config: host={}, port={}, clientId={}", 
                mqttProperties.getHost(), mqttProperties.getPort(), mqttProperties.getClientId());
        return MqttClient.builder()
                .useMqttVersion5()
                .serverHost(mqttProperties.getHost())
                .serverPort(mqttProperties.getPort())
                .identifier(mqttProperties.getClientId())
                .automaticReconnectWithDefaultConfig() // ⭐ 核心
                .simpleAuth()
                .username(mqttProperties.getUsername())
                .password(mqttProperties.getPassword().getBytes())
                .applySimpleAuth()
                .buildAsync();
    }
}
