package com.ruoyi.iot.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SseMessage<T> {

    private String type;   // init / update / heartbeat
    private T data;
    private long ts;
}