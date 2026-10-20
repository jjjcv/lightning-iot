package com.ruoyi.iot.mqtt;

import com.ruoyi.iot.scene.DeviceState;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;

@Component
public class DeviceEventBus {

    private final Sinks.Many<DeviceState> sink =
            Sinks.many().multicast().onBackpressureBuffer();

    public void publish(DeviceState msg) {
        sink.tryEmitNext(msg);
    }

    public Flux<DeviceState> flux() {
        return sink.asFlux();
    }
}