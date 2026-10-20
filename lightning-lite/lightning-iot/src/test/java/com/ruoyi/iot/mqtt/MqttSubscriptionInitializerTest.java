package com.ruoyi.iot.mqtt;

import com.hivemq.client.mqtt.datatypes.MqttQos;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

class MqttSubscriptionInitializerTest {

    @Test
    void subscribesToConfiguredTopicPattern() {
        SubscriptionRegistry registry = mock(SubscriptionRegistry.class);
        MqttProperties properties = new MqttProperties();
        properties.setTopicPattern("/product/+/properties/report");

        new MqttSubscriptionInitializer(registry, properties).init();

        verify(registry).register("/product/+/properties/report", MqttQos.AT_LEAST_ONCE);
    }
}
