package com.ruoyi.iot.metadata.codecs;



import com.ruoyi.iot.metadata.DataType;

import java.util.Map;

public interface DataTypeCodec<T extends DataType> {

    String getTypeId();

    T decode(T type, Map<String,Object> config);

    Map<String,Object> encode(T type);

}
