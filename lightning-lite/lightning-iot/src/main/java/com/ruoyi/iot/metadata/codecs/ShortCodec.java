package com.ruoyi.iot.metadata.codecs;


import com.ruoyi.iot.metadata.types.ShortType;

public class ShortCodec extends NumberCodec<ShortType> {

    @Override
    public String getTypeId() {
        return ShortType.ID;
    }

}
