package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.metadata.types.NumberType;
import com.ruoyi.iot.metadata.unit.ValueUnits;

import java.math.RoundingMode;
import java.util.Map;
import java.util.Optional;

public abstract class NumberCodec<T extends NumberType<?>> extends AbstractDataTypeCodec<T>{
    @Override
    public abstract String getTypeId();

    @Override
    public T decode(T type, Map<String, Object> config) {
        super.decode(type,config);
        JSONObject jsonObject = new JSONObject(config);
        Optional.ofNullable(jsonObject.getDouble("max"))
                .ifPresent(type::setMax);
        Optional.ofNullable(jsonObject.getDouble("min"))
                .ifPresent(type::setMin);
        Optional.ofNullable(jsonObject.getInteger("scale"))
                .ifPresent(type::setScale);
        Optional.ofNullable(jsonObject.getString("unit"))
                .flatMap(ValueUnits::lookup)
                .ifPresent(type::setUnit);
        Optional.ofNullable(jsonObject.getString("round"))
                .map(RoundingMode::valueOf)
                .ifPresent(type::setRound);
        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, T type) {
        encoded.put("max", type.getMax());
        encoded.put("min", type.getMin());
        encoded.put("scale", type.getScale());
        encoded.put("round", type.getRound().name());
        if (type.getUnit() != null) {
            encoded.put("unit", type.getUnit().getId());
        }
    }

}
