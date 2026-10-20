package com.ruoyi.iot.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 单位信息对象 unit
 * 
 * @author ruoyi
 * @date 2025-08-28
 */
public class Unit extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /**  */
    private Long id;

    /** 单位名称，如 千克 */
    @Excel(name = "单位名称，如 千克")
    private String name;

    /** 单位符号，如 kg */
    @Excel(name = "单位符号，如 kg")
    private String symbol;

    /** 所属单位分类 */
    @Excel(name = "所属单位分类")
    private Long categoryId;

    /** 相对于主单位的换算因子 */
    @Excel(name = "相对于主单位的换算因子")
    private BigDecimal conversionFactor;

    /** 是否为主单位 */
    @Excel(name = "是否为主单位")
    private Integer isBaseUnit;

    /** 说明，如 kg是质量主单位 */
    @Excel(name = "说明，如 kg是质量主单位")
    private String description;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date createdTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "更新时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date updatedTime;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }
    public void setSymbol(String symbol) 
    {
        this.symbol = symbol;
    }

    public String getSymbol() 
    {
        return symbol;
    }
    public void setCategoryId(Long categoryId) 
    {
        this.categoryId = categoryId;
    }

    public Long getCategoryId() 
    {
        return categoryId;
    }
    public void setConversionFactor(BigDecimal conversionFactor) 
    {
        this.conversionFactor = conversionFactor;
    }

    public BigDecimal getConversionFactor() 
    {
        return conversionFactor;
    }
    public void setIsBaseUnit(Integer isBaseUnit) 
    {
        this.isBaseUnit = isBaseUnit;
    }

    public Integer getIsBaseUnit() 
    {
        return isBaseUnit;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setCreatedTime(Date createdTime) 
    {
        this.createdTime = createdTime;
    }

    public Date getCreatedTime() 
    {
        return createdTime;
    }
    public void setUpdatedTime(Date updatedTime) 
    {
        this.updatedTime = updatedTime;
    }

    public Date getUpdatedTime() 
    {
        return updatedTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("symbol", getSymbol())
            .append("categoryId", getCategoryId())
            .append("conversionFactor", getConversionFactor())
            .append("isBaseUnit", getIsBaseUnit())
            .append("description", getDescription())
            .append("createdTime", getCreatedTime())
            .append("updatedTime", getUpdatedTime())
            .toString();
    }
}
