package com.ruoyi.iot.metadata;


import java.util.List;

public abstract class EventMetadata extends BaseMetadata implements JSONAble {

    //事件对应的方法名称（根据id生成）。
    protected String method;

    protected List<PropertyMetadata> outputs;

    public List<PropertyMetadata> getOutputs() {
        return outputs;
    }

    public void setOutputs(List<PropertyMetadata> outputs) {
        this.outputs = outputs;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }
}
