package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 产品类型对象 product_categories
 * 
 * @author ruoyi
 * @date 2025-03-05
 */
@Schema(description = "产品类型对象 product_categories") // 类级注解
public class ProductCategory extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 产品类型id */
    @Schema(description = "产品类型ID")
    private Long categoryId;

    /** 父类id */
    @Excel(name = "父类id")
    @Schema(description = "父类ID")
    private Long parentId;

    /** 祖级列表 */
    @Excel(name = "祖级列表")
    @Schema(description = "祖级列表")
    private String ancestors;

    /** 产品类型名称 */
    @Excel(name = "产品类型名称")
    @Schema(description = "产品类型名称")
    private String categoryName;

    /** 显示顺序 */
    @Excel(name = "显示顺序")
    @Schema(description = "显示顺序")
    private Long orderNum;

    /** 产品类型说明 */
    @Excel(name = "产品类型说明")
    @Schema(description = "产品类型说明")
    private String description;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    @Schema(description = "状态（0-正常，1-停用）")
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    @Schema(description = "删除标志（0-存在，2-删除）")
    private String delFlag;

    public void setCategoryId(Long categoryId) 
    {
        this.categoryId = categoryId;
    }

    public Long getCategoryId() 
    {
        return categoryId;
    }
    public void setParentId(Long parentId) 
    {
        this.parentId = parentId;
    }

    public Long getParentId() 
    {
        return parentId;
    }
    public void setAncestors(String ancestors) 
    {
        this.ancestors = ancestors;
    }

    public String getAncestors() 
    {
        return ancestors;
    }
    public void setCategoryName(String categoryName) 
    {
        this.categoryName = categoryName;
    }

    public String getCategoryName() 
    {
        return categoryName;
    }
    public void setOrderNum(Long orderNum) 
    {
        this.orderNum = orderNum;
    }

    public Long getOrderNum() 
    {
        return orderNum;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("categoryId", getCategoryId())
            .append("parentId", getParentId())
            .append("ancestors", getAncestors())
            .append("categoryName", getCategoryName())
            .append("orderNum", getOrderNum())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
