package com.ruoyi.iot.domain;

import com.ruoyi.iot.scene.DeviceState;
import lombok.Data;

@Data
public class SubscribeRequest {
    private String ticket;
    private DeviceState deviceState;
}
