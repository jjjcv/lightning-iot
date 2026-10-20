package com.ruoyi.iot.metadata.codecs;



import com.ruoyi.iot.metadata.types.DoubleType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DoubleCodec extends NumberCodec<DoubleType> {

    @Override
    public String getTypeId() {
        return DoubleType.ID;
    }

}
