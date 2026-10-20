package com.ruoyi.iot.utils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.HashMap;
import java.util.Map;

public class RelationSpec {
    public static final String OPTION_REVERSE = "reverse";
    private String objectType;
    private String relation;
    private Map<String, Object> options;
    private RelationSpec next;

    public RelationSpec() {
    }

    @JsonIgnore
    public boolean isReverse() {
        return this.options != null && Boolean.TRUE.equals(this.options.get("reverse"));
    }

    public void reverse(boolean reverse) {
        this.option("reverse", reverse);
    }

    public String toString() {
        String rel = this.relation;
        if (this.options != null) {
            rel = rel + "$" + String.join("$", this.options.keySet());
        }

        String expr = rel + "@" + this.objectType;
        if (this.next != null) {
            expr = expr + ":" + this.next;
        }

        return expr;
    }

    public RelationSpec option(String key, Object value) {
        if (this.options == null) {
            this.options = new HashMap();
        }

        this.options.put(key, value);
        return this;
    }

    public static RelationSpec of(Object spec) {
        if (spec instanceof RelationSpec) {
            return (RelationSpec)spec;
        } else {
            return parse(String.valueOf(spec));
        }
    }

    public static RelationSpec parse(String expr) {
        String[] objects = expr.split(":", 2);
        String[] first = objects[0].split("@");
        if (first.length != 2) {
            throw new UnsupportedOperationException("unsupported expression :" + objects[0]);
        } else {
            RelationSpec spec = new RelationSpec();
            String relation = first[0];
            if (relation.contains("$")) {
                String[] rel = relation.split("\\$", 2);
                relation = rel[0];

                for(int i = 1; i < rel.length; ++i) {
                    String opt = rel[i];
                    spec.option(opt, true);
                }
            }

            spec.relation = relation;
            spec.objectType = first[1];
            if (objects.length == 2) {
                spec.next = parse(objects[1]);
            }

            return spec;
        }
    }

    public String getObjectType() {
        return this.objectType;
    }

    public String getRelation() {
        return this.relation;
    }

    public Map<String, Object> getOptions() {
        return this.options;
    }

    public RelationSpec getNext() {
        return this.next;
    }

    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }

    public void setRelation(String relation) {
        this.relation = relation;
    }

    public void setOptions(Map<String, Object> options) {
        this.options = options;
    }

    public void setNext(RelationSpec next) {
        this.next = next;
    }
}

