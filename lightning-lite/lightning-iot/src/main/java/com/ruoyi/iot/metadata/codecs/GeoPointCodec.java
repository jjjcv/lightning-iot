package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;

import com.ruoyi.iot.metadata.types.GeoType;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class GeoPointCodec extends AbstractDataTypeCodec<GeoType> {

    @Override
    public String getTypeId() {
        return GeoType.ID;
    }

    @Override
    public GeoType decode(GeoType type, Map<String, Object> config) {
        super.decode(type, config);
        JSONObject jsonObject = new JSONObject(config);
        Optional.ofNullable(jsonObject.getString("latProperty"))
                .ifPresent(type::latProperty);
        Optional.ofNullable(jsonObject.getString("lonProperty"))
                .ifPresent(type::lonProperty);
        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, GeoType type) {
        encoded.put("latProperty", type.getLatProperty());
        encoded.put("lonProperty", type.getLonProperty());
    }


}
