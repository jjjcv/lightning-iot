package com.ruoyi.iot.metadata.types;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.ruoyi.iot.metadata.Converter;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValidateResult;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Getter
@Setter
public class ArrayType extends AbstractType<ArrayType> implements Converter<List<Object>> {

    public static final String ID = "array";

    private DataType elementType;

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getName() {
        return "数组";
    }

    @Override
    public Optional<Object> getExpand(String key) {
        return super.getExpand(key);
    }

    @Override
    public void setName(String name) {
        super.setName(name);
    }

    public ArrayType elementType(DataType elementType) {
        this.elementType = elementType;
        return this;
    }

    @Override
    public ValidateResult validate(Object value) {

        List<Object> listValue = convert(value);
        if (elementType != null && value instanceof Collection) {
            for (Object data : listValue) {
                ValidateResult result = elementType.validate(data);
                if (!result.isSuccess()) {
                    return result;
                }
            }
        }
        return ValidateResult.success(listValue);
    }

    @Override
    public String getType() {
        return super.getType();
    }

    @Override
    public Object format(Object value) {

        if (elementType != null && value instanceof Collection) {
            Collection<?> collection = ((Collection<?>) value);
            return new JSONArray(collection.stream()
                    .map(data -> elementType.format(data))
                    .collect(Collectors.toList()));
        }

        return JSON.toJSON(value);
    }

    @Override
    public List<Object> convert(Object value) {
        if (value instanceof Collection) {
            return ((Collection<?>) value).stream()
                    .map(val -> {
                        if (elementType instanceof Converter) {
                            return ((Converter<?>) elementType).convert(val);
                        }
                        return val;
                    }).collect(Collectors.toList());
        }
        if(value instanceof String){
            return JSON.parseArray(String.valueOf(value));
        }
        return Collections.singletonList(value);
    }
}
