package com.ruoyi.iot.protocol;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.metadata.*;
import lombok.Getter;
import lombok.Setter;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class ProtocolThingsMetadata implements Metadata, JSONAble {


    private JSONObject jsonObject;

    //物模型结构定义的访问URL
    @Setter
    @Getter
    private String schema;

    private volatile Map<String, PropertyMetadata> connectionProperties;

    private volatile Map<String, PropertyMetadata> dataPointProperties;

    @Getter
    @Setter
    private String id;

    @Getter
    @Setter
    private String name;

    @Getter
    @Setter
    private String description;

    @Setter
    private Map<String, Object> expands;

    public ProtocolThingsMetadata(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public ProtocolThingsMetadata(String json) {
        this.jsonObject = JSON.parseObject(json);
    }

    public ProtocolThingsMetadata(JSONObject jsonObject) {
        this.jsonObject = jsonObject;
    }


    public List<PropertyMetadata> getDataPointProperties() {
        if (dataPointProperties == null && jsonObject != null) {
            this.dataPointProperties = Optional
                    .ofNullable(jsonObject.getJSONArray("dataPointProperties"))
                    .map(Collection::stream)
                    .<Map<String, PropertyMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultPropertyMetadata::new)
                            .map(PropertyMetadata.class::cast)
                            .collect(Collectors.toMap(PropertyMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }
        if (dataPointProperties == null) {
            this.dataPointProperties = new LinkedHashMap<>();
        }
        return new ArrayList<>(dataPointProperties.values());
    }

    public List<PropertyMetadata> getConnectionProperties() {
        if (connectionProperties == null && jsonObject != null) {
            this.connectionProperties = Optional
                    .ofNullable(jsonObject.getJSONArray("connectionProperties"))
                    .map(Collection::stream)
                    .<Map<String, PropertyMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultPropertyMetadata::new)
                            .map(PropertyMetadata.class::cast)
                            .collect(Collectors.toMap(PropertyMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }
        if (connectionProperties == null) {
            this.connectionProperties = new LinkedHashMap<>();
        }
        return new ArrayList<>(connectionProperties.values());
    }



    public PropertyMetadata getConnectionPropertyOrNull(String id) {
        if (connectionProperties == null) {
            getConnectionProperties();
        }
        return connectionProperties == null ? null : connectionProperties.get(id);
    }

    public PropertyMetadata getDataPointPropertyOrNull(String id) {
        if (dataPointProperties == null) {
            getDataPointProperties();
        }
        return dataPointProperties == null ? null : dataPointProperties.get(id);
    }


    public PropertyMetadata findConnectionProperty(Predicate<PropertyMetadata> predicate) {
        for (PropertyMetadata metadata : getConnectionProperties()) {
            if (predicate.test(metadata)) {
                return metadata;
            }
        }
        return null;
    }


    public PropertyMetadata findDataPointProperty(Predicate<PropertyMetadata> predicate) {
        for (PropertyMetadata metadata : getDataPointProperties()) {
            if (predicate.test(metadata)) {
                return metadata;
            }
        }
        return null;
    }

    public void addDataPointProperty(PropertyMetadata metadata) {
        if (this.dataPointProperties == null) {
            this.dataPointProperties = new LinkedHashMap<>();
        }
        this.dataPointProperties.put(metadata.getId(), metadata);
    }


    public void addConnectionProperty(PropertyMetadata metadata) {
        if (this.connectionProperties == null) {
            this.connectionProperties = new LinkedHashMap<>();
        }
        this.connectionProperties.put(metadata.getId(), metadata);
    }




    public Map<String, Object> getExpands() {
        if (this.expands == null && jsonObject != null) {
            this.expands = jsonObject.getJSONObject("expands");
        }
        return this.expands;
    }

    @Override
    public JSONObject toJson() {
        return (JSONObject) JSON.toJSON(this);
    }

    @Override
    public void fromJson(JSONObject json) {
        this.jsonObject = json;
        this.dataPointProperties = null;
        this.connectionProperties = null;
        this.id = json.getString("id");
        this.name = json.getString("name");
        this.description = json.getString("description");
        this.expands = json.getJSONObject("expands");

    }



}
