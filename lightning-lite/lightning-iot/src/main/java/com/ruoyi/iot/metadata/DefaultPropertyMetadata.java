package com.ruoyi.iot.metadata;


import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.iot.metadata.codecs.DataTypeCodec;
import com.ruoyi.iot.metadata.codecs.DataTypeCodecs;
import com.ruoyi.iot.metadata.types.DataTypes;
import com.ruoyi.iot.metadata.types.UnknownType;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Optional;
import java.util.function.Supplier;

@Getter
@Setter
@NoArgsConstructor
public class DefaultPropertyMetadata extends PropertyMetadata {

    private transient JSONObject jsonObject;

    public DefaultPropertyMetadata(PropertyMetadata propertyMetadata) {
        BeanUtils.copyProperties(propertyMetadata, this);
    }

    public DefaultPropertyMetadata(JSONObject jsonObject) {
        fromJson(jsonObject);
    }


    @Override
    public JSONObject toJson() {
        return (JSONObject) JSON.toJSON(this);
    }

    @Override
    public void fromJson(JSONObject json) {
        this.jsonObject = json;
        this.id = json.getString("id");
        this.name = json.getString("name");
        this.description = json.getString("description");
        this.expands = json.getJSONObject("expands");

    }

    @Override
    public DataType getValueType() {
        if (dataType == null && jsonObject != null) {
            dataType = parseDataType();
        }
        return dataType;
    }


    protected DataType parseDataType() {
        JSONObject dataTypeJson = jsonObject.getJSONObject("valueType");
        if (dataTypeJson == null) {
            throw new IllegalArgumentException("属性" + getId() + "类型不能为空");
        }
        DataType dataType = Optional
                .ofNullable(dataTypeJson.getString("type"))
                .map(DataTypes::lookup)
                .map(Supplier::get)
                .orElseGet(UnknownType::new);

        getDataTypeCodec(dataType)
                .ifPresent(codec -> codec.decode(dataType, dataTypeJson));

        return dataType;
    }


    protected Optional<DataTypeCodec<DataType>> getDataTypeCodec(DataType dataType) {

        return DataTypeCodecs.getCodec(dataType.getId());
    }


}
