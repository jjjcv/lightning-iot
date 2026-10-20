package com.ruoyi.iot.metadata;

public interface Converter<T> {

    T convert(Object value);
}
