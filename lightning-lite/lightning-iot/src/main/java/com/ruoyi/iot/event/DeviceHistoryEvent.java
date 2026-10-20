package com.ruoyi.iot.event;

import org.springframework.context.ApplicationEvent;

import java.time.Clock;

public class DeviceHistoryEvent extends ApplicationEvent {

    public DeviceHistoryEvent(Object source) {
        super(source);
    }

    public DeviceHistoryEvent(Object source, Clock clock) {
        super(source, clock);
    }
}
