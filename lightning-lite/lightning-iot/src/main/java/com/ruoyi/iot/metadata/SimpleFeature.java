package com.ruoyi.iot.metadata;

public class SimpleFeature implements Feature{

    private String id;
    private String name;

    public String getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public SimpleFeature(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public SimpleFeature() {
    }
}
