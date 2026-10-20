package com.ruoyi.iot.metadata;

import com.alibaba.fastjson2.JSONObject;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.function.Predicate;

public interface ThingMetadata extends Metadata, JSONAble {
    List<PropertyMetadata> getProperties();

    List<FunctionMetadata> getFunctions();

    List<EventMetadata> getEvents();

    List<PropertyMetadata> getTags();

    default List<ThingMetadata> getModules() {
        return Collections.emptyList();
    }

    default ThingMetadata getModuleOrNull(String moduleId) {
        return this.getModule(moduleId).orElse(null);
    }

    default Optional<ThingMetadata> getModule(String moduleId) {
        return this.getModules().stream().filter((metadata) -> {
            return Objects.equals(moduleId, metadata.getId());
        }).findAny();
    }

    default Optional<EventMetadata> getEvent(String id) {
        return Optional.ofNullable(this.getEventOrNull(id));
    }

    EventMetadata getEventOrNull(String var1);

    default Optional<PropertyMetadata> getProperty(String id) {
        return Optional.ofNullable(this.getPropertyOrNull(id));
    }

    PropertyMetadata getPropertyOrNull(String var1);

    default Optional<FunctionMetadata> getFunction(String id) {
        return Optional.ofNullable(this.getFunctionOrNull(id));
    }

    FunctionMetadata getFunctionOrNull(String var1);

    default Optional<PropertyMetadata> getTag(String id) {
        return Optional.ofNullable(this.getTagOrNull(id));
    }

    PropertyMetadata getTagOrNull(String var1);

    default PropertyMetadata findProperty(Predicate<PropertyMetadata> predicate) {
        return (PropertyMetadata)this.getProperties().stream().filter(predicate).findAny().orElse(null);
    }

    default <T extends ThingMetadata> ThingMetadata merge(T metadata) {
        return merge(metadata, MergeOption.DEFAULT_OPTIONS);
    }

    default <T extends ThingMetadata> ThingMetadata merge(T metadata, MergeOption... options) {
        throw new UnsupportedOperationException("unsupported merge metadata");
    }

    @Override
    default ThingMetadata expand(String key, Object value) {
        Metadata.super.expand(key, value);
        return this;
    }

    @Override
    default JSONObject toJson() {
        return JSONAble.super.toJson();
    }

}
