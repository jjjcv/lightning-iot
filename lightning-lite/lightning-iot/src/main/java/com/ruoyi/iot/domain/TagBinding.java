package com.ruoyi.iot.domain;

/** 批量读取对象标签的查询结果。 */
public class TagBinding {
    private String objectId;
    private Long tagId;
    private String tagName;
    public String getObjectId() { return objectId; }
    public void setObjectId(String objectId) { this.objectId = objectId; }
    public Long getTagId() { return tagId; }
    public void setTagId(Long tagId) { this.tagId = tagId; }
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
}
