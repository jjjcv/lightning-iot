package com.ruoyi.iot.metadata.codecs;


import com.ruoyi.iot.metadata.types.IntType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class IntCodec extends NumberCodec<IntType> {

    @Override
    public String getTypeId() {
        return IntType.ID;
    }


}
