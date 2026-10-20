package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;

import com.ruoyi.iot.metadata.types.BooleanType;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class BooleanCodec extends AbstractDataTypeCodec<BooleanType> {

    @Override
    public String getTypeId() {
        return BooleanType.ID;
    }

    @Override
    public BooleanType decode(BooleanType type, Map<String, Object> config) {
        super.decode(type,config);
        JSONObject jsonObject = new JSONObject(config);

        Optional.ofNullable(jsonObject.getString("trueText"))
                .ifPresent(type::setTrueText);
        Optional.ofNullable(jsonObject.getString("falseText"))
                .ifPresent(type::setFalseText);
        Optional.ofNullable(jsonObject.getString("trueValue"))
                .ifPresent(type::setTrueValue);
        Optional.ofNullable(jsonObject.getString("falseValue"))
                .ifPresent(type::setFalseValue);
        Optional.ofNullable(jsonObject.getString("description"))
                .ifPresent(type::setDescription);

        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, BooleanType type) {
        super.doEncode(encoded, type);
        encoded.put("trueText", type.getTrueText());
        encoded.put("falseText", type.getFalseText());
        encoded.put("trueValue", type.getTrueValue());
        encoded.put("falseValue", type.getFalseValue());

    }
}
