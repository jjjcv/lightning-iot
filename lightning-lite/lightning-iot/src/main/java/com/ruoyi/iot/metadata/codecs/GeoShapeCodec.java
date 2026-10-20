package com.ruoyi.iot.metadata.codecs;


import com.ruoyi.iot.metadata.types.GeoShapeType;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class GeoShapeCodec extends AbstractDataTypeCodec<GeoShapeType> {

    @Override
    public String getTypeId() {
        return GeoShapeType.ID;
    }

}
