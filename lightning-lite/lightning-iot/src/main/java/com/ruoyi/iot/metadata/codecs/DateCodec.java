package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;

import com.ruoyi.iot.metadata.types.DateTimeType;
import lombok.Getter;
import lombok.Setter;

import java.time.ZoneId;
import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class DateCodec extends AbstractDataTypeCodec<DateTimeType> {

    @Override
    public String getTypeId() {
        return DateTimeType.ID;
    }

    @Override
    public DateTimeType decode(DateTimeType type, Map<String, Object> config) {
        super.decode(type,config);
        JSONObject jsonObject = new JSONObject(config);
        Optional.ofNullable(jsonObject.getString("format"))
                .ifPresent(type::setFormat);
        Optional.ofNullable(jsonObject.getString("tz"))
                .map(ZoneId::of)
                .ifPresent(type::setZoneId);


        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, DateTimeType type) {
        super.doEncode(encoded, type);
        encoded.put("format", type.getFormat());
        encoded.put("tz", type.getZoneId().toString());

    }
}
