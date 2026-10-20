package com.ruoyi.iot.metadata.types;

import com.ruoyi.iot.metadata.Converter;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValidateResult;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StringType extends AbstractType<StringType> implements DataType, Converter<String> {
    public static final String ID = "string";
    public static final StringType GLOBAL = new StringType();

    //字符长度
    private Integer maxLength;

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getName() {
        return "字符串";
    }

    @Override
    public ValidateResult validate(Object value) {
        String string = String.valueOf(value);
        if (maxLength != null && string.length() > maxLength) {
            return ValidateResult.fail("字符串超过最大长度:" + maxLength);
        }
        return ValidateResult.success(string);
    }

    @Override
    public String format(Object value) {
        return String.valueOf(value);
    }

    @Override
    public String convert(Object value) {
        return value == null ? null : String.valueOf(value);
    }
}
