package com.ruoyi.iot.event;

import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class EdgeStatusEvent extends ApplicationEvent {

    private final Boolean status;
    private final String edgeDeviceId;

    public EdgeStatusEvent(Object source, Boolean status, String edgeDeviceId) {
        super(source);
        this.status = status;
        this.edgeDeviceId = edgeDeviceId;
    }

    public static EdgeStatusEvent of(Boolean status, String edgeDeviceId){
        return new EdgeStatusEvent(Boolean.TRUE, status, edgeDeviceId);
    }

}
