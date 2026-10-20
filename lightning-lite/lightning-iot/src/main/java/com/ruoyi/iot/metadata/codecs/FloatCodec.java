package com.ruoyi.iot.metadata.codecs;



import com.ruoyi.iot.metadata.types.FloatType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FloatCodec extends NumberCodec<FloatType> {

    @Override
    public String getTypeId() {
        return FloatType.ID;
    }

}
