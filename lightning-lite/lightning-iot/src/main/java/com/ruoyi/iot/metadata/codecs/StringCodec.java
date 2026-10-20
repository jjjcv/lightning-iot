package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.metadata.types.BooleanType;
import com.ruoyi.iot.metadata.types.StringType;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class StringCodec extends AbstractDataTypeCodec<StringType> {

    @Override
    public String getTypeId() {
        return StringType.ID;
    }


    @Override
    public StringType decode(StringType type, Map<String, Object> config) {
        super.decode(type,config);
        JSONObject jsonObject = new JSONObject(config);

        Optional.ofNullable(jsonObject.getInteger("maxLength"))
                .ifPresent(type::setMaxLength);

        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, StringType type) {
        super.doEncode(encoded, type);
        encoded.put("maxLength", type.getMaxLength());
    }


}
