package com.ruoyi.iot.metadata;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public abstract class PropertyMetadata extends BaseMetadata implements JSONAble {

    protected DataType dataType;

    protected AccessMode accessMode;

    public abstract  DataType getValueType();
}