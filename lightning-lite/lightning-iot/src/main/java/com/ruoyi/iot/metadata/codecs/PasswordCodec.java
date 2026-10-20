package com.ruoyi.iot.metadata.codecs;



 import com.ruoyi.iot.metadata.types.PasswordType;
 import lombok.Getter;
 import lombok.Setter;

@Getter
@Setter
public class PasswordCodec extends AbstractDataTypeCodec<PasswordType> {

    @Override
    public String getTypeId() {
        return PasswordType.ID;
    }

}
