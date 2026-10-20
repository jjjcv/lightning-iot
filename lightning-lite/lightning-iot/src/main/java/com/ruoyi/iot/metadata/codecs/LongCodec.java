package com.ruoyi.iot.metadata.codecs;



import com.ruoyi.iot.metadata.types.LongType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LongCodec extends NumberCodec<LongType> {

    @Override
    public String getTypeId() {
        return LongType.ID;
    }

}
