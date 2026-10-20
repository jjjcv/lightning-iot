package com.ruoyi.iot.metadata.codecs;




import com.ruoyi.iot.metadata.DataType;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class DataTypeCodecs {

    private static final Map<String, DataTypeCodec<? extends DataType>> codecMap = new HashMap<>();

    static {
        register(new ArrayCodec());
        register(new BooleanCodec());
        register(new DateCodec());
        register(new DoubleCodec());
        register(new EnumCodec());
        register(new FloatCodec());
        register(new GeoPointCodec());
        register(new IntCodec());
        register(new LongCodec());
        register(new ObjectCodec());
        register(new StringCodec());
        register(new PasswordCodec());
        register(new FileCodec());
        register(new GeoShapeCodec());
        register(new UserCodec());
        register(new ShortCodec());
    }

    public static void register(DataTypeCodec<? extends DataType> codec) {
        codecMap.put(codec.getTypeId(), codec);
    }

    @SuppressWarnings("all")
    public static Optional<DataTypeCodec<DataType>> getCodec(String typeId) {

        return Optional.ofNullable((DataTypeCodec) codecMap.get(typeId));
    }

    public static DataType decode(DataType type, Map<String, Object> config) {
        if (type == null) {
            return null;
        }
        return getCodec(type.getId())
                .map(codec -> codec.decode(type, config))
                .orElse(type);
    }

    public static Optional<Map<String, Object>> encode(DataType type) {
        if (type == null) {
            return Optional.empty();
        }
        return getCodec(type.getId())
                .map(codec -> codec.encode(type));
    }
}
