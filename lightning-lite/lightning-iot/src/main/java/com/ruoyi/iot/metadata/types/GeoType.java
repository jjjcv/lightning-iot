package com.ruoyi.iot.metadata.types;



import com.ruoyi.iot.metadata.Converter;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.FormatSupport;
import com.ruoyi.iot.metadata.ValidateResult;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
public class GeoType extends AbstractType<GeoType> implements DataType, FormatSupport, Converter<GeoPoint> {
    public static final String ID = "geoPoint";

    public static final GeoType GLOBAL = new GeoType();

    //经度字段
    private String latProperty = "lat";

    //纬度字段
    private String lonProperty = "lon";

    public GeoType latProperty(String property) {
        this.latProperty = property;
        return this;
    }

    public GeoType lonProperty(String property) {
        this.lonProperty = property;
        return this;
    }

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getName() {
        return "地理位置";
    }

    public Map<String, Object> convertToMap(Object value) {
        Map<String, Object> mapGeoPoint = new HashMap<>();

        GeoPoint point = convert(value);
        if (point != null) {
            mapGeoPoint.put("lat", point.getLat());
            mapGeoPoint.put("lon", point.getLon());
        }
        return mapGeoPoint;
    }

    public GeoPoint convert(Object value) {
        return GeoPoint.of(value);
    }

    @Override
    public ValidateResult validate(Object value) {

        GeoPoint geoPoint = convert(value);

        return geoPoint == null
                ? ValidateResult.fail("不支持的Geo格式:" + value)
                : ValidateResult.success(geoPoint);
    }

    @Override
    public String format(Object value) {
        GeoPoint geoPoint = convert(value);

        return String.valueOf(geoPoint);
    }


}
