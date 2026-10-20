package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.metadata.UserType;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class UserCodec extends AbstractDataTypeCodec<UserType> {

    @Override
    public String getTypeId() {
        return UserType.ID;
    }

    @Override
    public UserType decode(UserType type, Map<String, Object> config) {
        super.decode(type,config);
        JSONObject jsonObject = new JSONObject(config);
        Optional.ofNullable(jsonObject.getString("property"))
                .ifPresent(type::setProperty);
        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, UserType type) {
        super.doEncode(encoded, type);
        encoded.put("property", type.getProperty());

    }
}
