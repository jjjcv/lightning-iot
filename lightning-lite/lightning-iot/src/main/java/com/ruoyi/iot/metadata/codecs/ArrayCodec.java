package com.ruoyi.iot.metadata.codecs;


import com.alibaba.fastjson2.JSONObject;

import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.types.ArrayType;
import com.ruoyi.iot.metadata.types.DataTypes;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

@Getter
@Setter
public class ArrayCodec extends AbstractDataTypeCodec<ArrayType> {

    @Override
    public String getTypeId() {
        return ArrayType.ID;
    }

    @Override
    public ArrayType decode(ArrayType type, Map<String, Object> config) {
        super.decode(type, config);
        JSONObject jsonObject = new JSONObject(config);
        Optional.ofNullable(jsonObject.get("elementType"))
                .map(v -> {
                    if (v instanceof Map) {
                        return new JSONObject(((Map) v));
                    }
                    JSONObject eleType = new JSONObject();
                    eleType.put("type", v);
                    return eleType;
                })
                .map(eleType -> {
                    DataType dataType = DataTypes.lookup(eleType.getString("type")).get();

                    DataTypeCodecs.getCodec(dataType.getId())
                            .ifPresent(codec -> codec.decode(dataType, eleType));

                    return dataType;
                })
                .ifPresent(type::setElementType);

        return type;
    }

    @Override
    protected void doEncode(Map<String, Object> encoded, ArrayType type) {
        super.doEncode(encoded, type);
        DataTypeCodecs.getCodec(type.getElementType().getId())
                .ifPresent(codec -> encoded.put("elementType", codec.encode(type.getElementType())));

    }
}
