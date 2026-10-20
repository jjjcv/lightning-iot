package com.ruoyi.iot.metadata.codecs;



import com.ruoyi.iot.metadata.DataType;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public abstract class AbstractDataTypeCodec<T extends DataType> implements DataTypeCodec<T> {

    @Override
    public T decode(T type, Map<String, Object> config) {
        Optional.ofNullable(config.get("description"))
                .map(String::valueOf)
                .ifPresent(type::setDescription);

        Optional.ofNullable(config.get("expands"))
                .filter(Map.class::isInstance)
                .map(Map.class::cast)
                .ifPresent(type::setExpands);
        return type;
    }

    @Override
    public Map<String, Object> encode(T type) {
        Map<String, Object> encoded = new HashMap<>();
        encoded.put("type", getTypeId());
        encoded.put("description", type.getDescription());
        encoded.put("expands", type.getExpands());
        doEncode(encoded, type);
        return encoded;
    }

    protected void doEncode(Map<String, Object> encoded, T type) {

    }
}
