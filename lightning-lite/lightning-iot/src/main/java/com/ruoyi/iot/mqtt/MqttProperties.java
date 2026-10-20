package com.ruoyi.iot.mqtt;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Setter
@Getter
@Configuration
@ConfigurationProperties(prefix = "mqtt")
public class MqttProperties {

    // Getter & Setter
    private boolean enabled = true;
    private String host;
    private int port;
    private String clientId;
    private String username;
    private String password;
    private int qos;
    private String topicPattern;

}
