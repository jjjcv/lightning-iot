package com.ruoyi.iot.metadata;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

public abstract class FunctionMetadata extends BaseMetadata implements JSONAble {

    //事件对应的方法名称（根据id生成）。
    @Setter
    @Getter
    protected String method;

    protected List<PropertyMetadata> inputs;

    @Setter
    protected DataType outputs;

    @Setter
    protected boolean async;

    /**
     * @return 是否异步
     */
    boolean isAsync() {
        return false;
    }
    /**
     * @return 输入参数定义
     */
    @NotNull
    public void setInputs(List<PropertyMetadata> inputs) {
        this.inputs = inputs;
    }

    public @Nonnull List<PropertyMetadata> getInputs() {
        if (inputs == null) {
            return Collections.emptyList();
        }
        return inputs;
    }

    /**
     * @return 输出类型，为null表示无输出
     */
    @Nullable
    public DataType getOutputs() {
        return this.outputs;
    }

}