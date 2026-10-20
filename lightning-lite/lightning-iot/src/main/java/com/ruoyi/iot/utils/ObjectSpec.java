package com.ruoyi.iot.utils;

public class ObjectSpec {
    private String objectType;
    private String objectId;
    private RelationSpec related;

    public ObjectSpec() {
    }

    public String toString() {
        String expr = this.objectId + "@" + this.objectType;
        if (this.related != null) {
            expr = expr + ":" + this.related;
        }

        return expr;
    }

    public static ObjectSpec parse(String expr) {
        String[] objects = expr.split(":", 2);
        String[] first = objects[0].split("@");
        if (first.length != 2) {
            throw new UnsupportedOperationException("unsupported expression :" + objects[0]);
        } else {
            ObjectSpec spec = new ObjectSpec();
            spec.objectId = first[0];
            spec.objectType = first[1];
            if (objects.length == 2) {
                spec.related = RelationSpec.parse(objects[1]);
            }

            return spec;
        }
    }

    public String getObjectType() {
        return this.objectType;
    }

    public String getObjectId() {
        return this.objectId;
    }

    public RelationSpec getRelated() {
        return this.related;
    }

    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }

    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }

    public void setRelated(RelationSpec related) {
        this.related = related;
    }
}