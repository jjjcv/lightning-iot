package com.ruoyi.iot.metadata.types;


import com.ruoyi.iot.metadata.DataType;
import lombok.Getter;
import lombok.Setter;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.Map;


@Getter
@Setter
public abstract class AbstractType<Self extends AbstractType<Self>> implements DataType {

    private Map<String, Object> expands;

    private String description;

    public Self expands(Map<String, Object> expands) {
        if (CollectionUtils.isEmpty(expands)) {
            return castSelf();
        }
        if (this.expands == null) {
            this.expands = new HashMap<>();
        }
        this.expands.putAll(expands);
        return castSelf();
    }

    public Self expand(String configKey, Object value) {

        if (value == null) {
            return castSelf();
        }
        if (expands == null) {
            expands = new HashMap<>();
        }
        expands.put(configKey, value);
        return castSelf();
    }

    public Self description(String description) {
        this.description = description;
        return castSelf();
    }

    @SuppressWarnings("all")
    protected Self castSelf() {
        return (Self) this;
    }

    @Override
    public String toString() {
        return getType();
    }
}
