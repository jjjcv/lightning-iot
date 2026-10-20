package com.ruoyi.iot.metadata;

public interface Feature {
    String getId();

    String getName();

    default String getType() {
        return this.getClass().getSimpleName();
    }

    default boolean isDeprecated() {
        return null != this.getClass().getAnnotation(Deprecated.class);
    }

    static Feature of(String id, String name) {
        return new SimpleFeature(id, name);
    }
}
