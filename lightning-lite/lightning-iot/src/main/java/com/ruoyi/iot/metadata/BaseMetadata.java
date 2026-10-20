package com.ruoyi.iot.metadata;

import lombok.Getter;
import lombok.Setter;

import java.util.Map;
import java.util.Optional;

public abstract class BaseMetadata implements Metadata{

    @Setter
    protected String id;

    protected String name;

    @Getter
    @Setter
    protected Boolean required;

    protected String description;

    protected Map<String, Object> expands;

    @Override
    public String getId() {
        return this.id;
    }

    @Override
    public String getName() {
        return this.name;
    }

    @Override
    public String getDescription() {
        return this.description;
    }

    @Override
    public Map<String, Object> getExpands() {
        return this.expands;
    }

    @Override
    public Optional<Object> getExpand(String key) {
        return Metadata.super.getExpand(key);
    }

    @Override
    public void setExpands(Map<String, Object> expands) {
        this.expands = expands;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public void setDescription(String description) {
        this.description = description;
    }

}
