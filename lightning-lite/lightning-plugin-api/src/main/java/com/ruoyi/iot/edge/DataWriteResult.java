package com.ruoyi.iot.edge;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DataWriteResult {

    private Boolean result;
    private String message;


    public static DataWriteResult of(Boolean result, String message){
        return new DataWriteResult(result, message);
    }

}
