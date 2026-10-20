package com.ruoyi.iot.event;

import com.ruoyi.iot.edge.DataPoint;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

import java.util.Map;


@Getter
public class DeviceBindingEvent extends ApplicationEvent {

    private final String edgeDeviceId;

    public DeviceBindingEvent(Map<String, DataPoint> source, String edgeDeviceId) {
        super(source);
        this.edgeDeviceId = edgeDeviceId;
    }

    public static DeviceBindingEvent of(Map<String, DataPoint> source, String edgeDeviceId){
        return new DeviceBindingEvent(source, edgeDeviceId);
    }





}
