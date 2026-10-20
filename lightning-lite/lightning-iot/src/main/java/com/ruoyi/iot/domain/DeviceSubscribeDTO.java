package com.ruoyi.iot.domain;

import lombok.Data;

import java.util.List;

@Data
public class DeviceSubscribeDTO {
    private String productId;
    private String deviceId;
    private List<String> props;
}
