package com.ruoyi.iot.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 标签详情对象 tag_detail
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
public class TagDetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 标签id */
    private Long tagId;

    /** 标签名称 */
    @Excel(name = "标签名称")
    private String tagName;

    /** 标签描述 */
    @Excel(name = "标签描述")
    private String description;

    /** 字典类型 */
    @Excel(name = "字典类型")
    private String tagType;

    /** 样式属性（其他样式扩展） */
    @Excel(name = "样式属性", readConverterExp = "其=他样式扩展")
    private String cssClass;

    /** 直接关联数量，设备数不包含产品标签继承。 */
    @Excel(name = "关联产品数")
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Long productCount;
    @Excel(name = "关联设备数")
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Long deviceCount;
    public Long getProductCount() { return productCount; }
    public void setProductCount(Long productCount) { this.productCount = productCount; }
    public Long getDeviceCount() { return deviceCount; }
    public void setDeviceCount(Long deviceCount) { this.deviceCount = deviceCount; }

    public void setTagId(Long tagId) 
    {
        this.tagId = tagId;
    }

    public Long getTagId() 
    {
        return tagId;
    }
    public void setTagName(String tagName) 
    {
        this.tagName = tagName;
    }

    public String getTagName() 
    {
        return tagName;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setTagType(String tagType) 
    {
        this.tagType = tagType;
    }

    public String getTagType() 
    {
        return tagType;
    }
    public void setCssClass(String cssClass) 
    {
        this.cssClass = cssClass;
    }

    public String getCssClass() 
    {
        return cssClass;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("tagId", getTagId())
            .append("tagName", getTagName())
            .append("description", getDescription())
            .append("tagType", getTagType())
            .append("cssClass", getCssClass())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
