package com.ruoyi.iot.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WsMessage<T> {

    private String type;   // init / update
    private T data;
    private long timestamp;
}
