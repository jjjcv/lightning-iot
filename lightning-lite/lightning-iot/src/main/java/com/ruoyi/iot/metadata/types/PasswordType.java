package com.ruoyi.iot.metadata.types;



import com.ruoyi.iot.metadata.Converter;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValidateResult;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PasswordType extends AbstractType<PasswordType> implements DataType, Converter<String> {
    public static final String ID = "password";
    public static final PasswordType GLOBAL = new PasswordType();

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getName() {
        return "密码";
    }

    @Override
    public ValidateResult validate(Object value) {
        return ValidateResult.success(String.valueOf(value));
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
