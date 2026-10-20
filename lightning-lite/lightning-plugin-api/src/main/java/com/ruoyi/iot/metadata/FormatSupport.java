package com.ruoyi.iot.metadata;

public interface FormatSupport {
    /**
     * 对值进行格式化
     *
     * @param value 值
     * @return 格式化后的值
     */
    Object format(Object value);
}
