package com.ruoyi.iot.utils;

import lombok.Getter;
import lombok.Setter;

import org.springframework.beans.BeanUtils;
import org.springframework.util.Assert;


import java.io.Serializable;
import java.util.*;


/**
 * 变量值来源描述
 *
 * @author zhouhao
 * @since 2.0
 */
@Getter
@Setter
public class VariableSource implements Serializable {
    private static final long serialVersionUID = 1L;

    // 来源
    private Source source;

    // 固定值,[source]为[fixed]时不能为空
    private Object value;

    // 上游key,[source]为[upper]时不能为空
    private String upperKey;

    // 关联,[source]为[relation]时不能为空
    private VariableObjectSpec relation;

    // 拓展信息
    private Map<String, Object> options;

    public Map<String, Object> toMap() {

        Map<String, Object> map = new HashMap<>();

        BeanUtils.copyProperties(this, map);

        return map;
    }

    public void validate() {
        Assert.notNull(source, "source can not be null");
        switch (source) {
            case fixed:
                Assert.notNull(value, "value can not be null");
                break;
            case upper:
                Assert.hasText(upperKey, "upperKey can not be empty");
                break;
            case relation:
                Assert.notNull(relation, "relation can not be null");
                relation.validate();
                break;
        }
    }

    public static VariableSource fixed(Object value) {
        VariableSource variableSource = new VariableSource();
        variableSource.setSource(Source.fixed);
        variableSource.setValue(value);
        return variableSource;
    }

    public static VariableSource upper(String key) {
        VariableSource variableSource = new VariableSource();
        variableSource.setSource(Source.upper);
        variableSource.setUpperKey(key);
        return variableSource;
    }

    public static VariableSource relation(VariableObjectSpec spec) {
        VariableSource variableSource = new VariableSource();
        variableSource.setSource(Source.relation);
        variableSource.setRelation(spec);
        return variableSource;
    }






    public enum Source {
        //固定值
        fixed,
        //来自上游
        upper,
        //通过关系选择
        relation;

        public static Optional<Source> of(String source) {
            for (Source value : values()) {
                if (value.name().equals(source)) {
                    return Optional.of(value);
                }
            }
            return Optional.empty();
        }
    }
}
