package com.ruoyi.iot.metadata.codecs;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.metadata.DefaultPropertyMetadata;
import com.ruoyi.iot.metadata.PropertyMetadata;
import com.ruoyi.iot.metadata.types.ObjectType;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Getter
@Setter
public class ObjectCodec extends AbstractDataTypeCodec<ObjectType> {

    @Override
    public String getTypeId() {
        return ObjectType.ID;
    }

    @Override
    public ObjectType decode(ObjectType type, Map<String, Object> config) {
        super.decode(type, config);
        JSONObject jsonObject = new JSONObject(config);

        Optional.ofNullable(jsonObject.getJSONArray("properties"))
                .map(list -> list
                        .stream()
                        .map(JSON::toJSON)
                        .map(JSONObject.class::cast)
                        .<PropertyMetadata>map(DefaultPropertyMetadata::new)
                        .collect(Collectors.toList()))
                .ifPresent(type::setProperties);


        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, ObjectType type) {
        super.doEncode(encoded, type);
        if (type.getProperties() != null) {
            encoded.put("properties", type
                    .getProperties()
                    .stream()
                    .map(DefaultPropertyMetadata::new)
                    .map(PropertyMetadata::toJson)
                    .collect(Collectors.toList()));
        }

    }
}
