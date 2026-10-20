package com.ruoyi.iot.metadata;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import lombok.Getter;
import lombok.Setter;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class DefaultThingsMetadata implements ThingMetadata{


    private JSONObject jsonObject;

    //物模型结构定义的访问URL
    @Setter
    @Getter
    private String schema;

    private volatile Map<String, PropertyMetadata> properties;

    private volatile Map<String, FunctionMetadata> functions;

    private volatile Map<String, EventMetadata> events;

    private volatile Map<String, PropertyMetadata> tags;

    private volatile List<PropertyMetadata> propertyMetadataList;

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

    public DefaultThingsMetadata(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public DefaultThingsMetadata(JSONObject jsonObject) {
        fromJson(jsonObject);
    }

    @Override
    public List<PropertyMetadata> getProperties() {
        if (this.propertyMetadataList.isEmpty()) {
            return this.propertyMetadataList;
        }
        if (this.properties == null && jsonObject != null) {
            this.properties = Optional
                    .ofNullable(jsonObject.getJSONArray("properties"))
                    .map(Collection::stream)
                    .<Map<String, PropertyMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultPropertyMetadata::new)
                            .map(PropertyMetadata.class::cast)
                            .collect(Collectors.toMap(PropertyMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }

        if (this.propertyMetadataList == null && this.properties != null) {
            this.propertyMetadataList = List.copyOf(this.properties.values());
            return this.propertyMetadataList;
        }
        return Collections.emptyList();
    }

    @Override
    public List<FunctionMetadata> getFunctions() {
        if (functions == null && jsonObject != null) {
            functions = Optional
                    .ofNullable(jsonObject.getJSONArray("functions"))
                    .map(Collection::stream)
                    .<Map<String, FunctionMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultFunctionMetadata::new)
                            .map(FunctionMetadata.class::cast)
                            .collect(Collectors.toMap(FunctionMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }
        if (functions == null) {
            this.functions = new LinkedHashMap<>();
        }
        return new ArrayList<>(functions.values());
    }

    @Override
    public List<PropertyMetadata> getTags() {
        if (tags == null && jsonObject != null) {
            tags = Optional
                    .ofNullable(jsonObject.getJSONArray("tags"))
                    .map(Collection::stream)
                    .<Map<String, PropertyMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultPropertyMetadata::new)
                            .map(PropertyMetadata.class::cast)
                            .collect(Collectors.toMap(PropertyMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }
        if (tags == null) {
            this.tags = new LinkedHashMap<>();
        }
        return new ArrayList<>(tags.values());
    }

    @Override
    public List<EventMetadata> getEvents() {
        if (events == null && jsonObject != null) {
            events = Optional
                    .ofNullable(jsonObject.getJSONArray("events"))
                    .map(Collection::stream)
                    .<Map<String, EventMetadata>>map(stream -> stream
                            .map(JSONObject.class::cast)
                            .map(DefaultEventMetadata::new)
                            .map(EventMetadata.class::cast)
                            .collect(Collectors.toMap(EventMetadata::getId, Function.identity(), (a, b) -> a, LinkedHashMap::new))
                    )
                    .orElse(Collections.emptyMap());
        }
        if (events == null) {
            this.events = new LinkedHashMap<>();
        }
        return new ArrayList<>(events.values());
    }

    @Override
    public EventMetadata getEventOrNull(String id) {
        if (events == null) {
            getEvents();
        }
        return events.get(id);
    }

    @Override
    public PropertyMetadata getPropertyOrNull(String id) {
        if (properties == null) {
            getProperties();
        }
        return properties == null ? null : properties.get(id);
    }

    @Override
    public FunctionMetadata getFunctionOrNull(String id) {
        if (functions == null) {
            getFunctions();
        }
        return functions == null ? null : functions.get(id);
    }

    @Override
    public PropertyMetadata getTagOrNull(String id) {
        if (tags == null) {
            getTags();
        }
        return tags == null ? null : tags.get(id);
    }

    @Override
    public PropertyMetadata findProperty(Predicate<PropertyMetadata> predicate) {
        for (PropertyMetadata metadata : getProperties()) {
            if (predicate.test(metadata)) {
                return metadata;
            }
        }
        return null;
    }

    public void addProperty(PropertyMetadata metadata) {
        if (this.properties == null) {
            this.properties = new LinkedHashMap<>();
        }
        this.properties.put(metadata.getId(), metadata);
        this.propertyMetadataList = Collections.unmodifiableList(new ArrayList<>(this.properties.values()));
    }

    public void addFunction(FunctionMetadata metadata) {
        if (this.functions == null) {
            this.functions = new LinkedHashMap<>();
        }
        this.functions.put(metadata.getId(), metadata);
    }

    public void addEvent(EventMetadata metadata) {
        if (this.events == null) {
            this.events = new LinkedHashMap<>();
        }
        this.events.put(metadata.getId(), metadata);
    }

    public void addTag(PropertyMetadata metadata) {
        if (this.tags == null) {
            this.tags = new LinkedHashMap<>();
        }
        this.tags.put(metadata.getId(), metadata);
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
        this.properties = null;
        this.events = null;
        this.functions = null;
        this.tags = null;
        this.id = json.getString("id");
        this.name = json.getString("name");
        this.description = json.getString("description");
        this.expands = json.getJSONObject("expands");

    }



}
