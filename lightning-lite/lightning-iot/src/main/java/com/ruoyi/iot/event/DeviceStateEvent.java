package com.ruoyi.iot.event;

import com.ruoyi.iot.scene.DeviceState;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;


/**
 * 设备状态上报事件
 * 设备直接上报属性时触发，携带设备状态（产品ID、设备ID、属性集合）
 */
@Getter
public class DeviceStateEvent extends ApplicationEvent {

    private final DeviceState deviceState;

    public DeviceStateEvent(Object source, DeviceState deviceState) {
        super(source);
        this.deviceState = deviceState;
    }

    public static DeviceStateEvent of(DeviceState deviceState) {
        return new DeviceStateEvent(deviceState, deviceState);
    }




}
