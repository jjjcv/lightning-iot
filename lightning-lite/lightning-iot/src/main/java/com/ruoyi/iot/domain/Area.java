package com.ruoyi.iot.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 区域信息对象 areas
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
public class Area extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /**  */
    private Long id;

    /** 父区域ID */
    @Excel(name = "父区域ID")
    private Long parentAreaId;

    /** 祖级列表 */
    @Excel(name = "祖级列表")
    private String ancestors;

    /** 建筑id */
    @Excel(name = "建筑id")
    private Long buildingId;

    /** 区域编码 */
    @Excel(name = "区域编码")
    private String areaCode;

    /** 区域名称 */
    @Excel(name = "区域名称")
    private String areaName;

    /** 区域类型 */
    @Excel(name = "区域类型")
    private String areaType;

    /** 区域面积(m²) */
    @Excel(name = "区域面积(m²)")
    private BigDecimal areaSize;

    /** 所在楼层 */
    @Excel(name = "所在楼层")
    private Long floorNum;

    /** 所属部门 */
    @Excel(name = "所属部门")
    private String department;

    /** 人员数量 */
    @Excel(name = "人员数量")
    private Long personnelCount;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setParentAreaId(Long parentAreaId) 
    {
        this.parentAreaId = parentAreaId;
    }

    public Long getParentAreaId() 
    {
        return parentAreaId;
    }
    public void setAncestors(String ancestors) 
    {
        this.ancestors = ancestors;
    }

    public String getAncestors() 
    {
        return ancestors;
    }
    public void setBuildingId(Long buildingId) 
    {
        this.buildingId = buildingId;
    }

    public Long getBuildingId() 
    {
        return buildingId;
    }
    public void setAreaCode(String areaCode) 
    {
        this.areaCode = areaCode;
    }

    public String getAreaCode() 
    {
        return areaCode;
    }
    public void setAreaName(String areaName) 
    {
        this.areaName = areaName;
    }

    public String getAreaName() 
    {
        return areaName;
    }
    public void setAreaType(String areaType) 
    {
        this.areaType = areaType;
    }

    public String getAreaType() 
    {
        return areaType;
    }
    public void setAreaSize(BigDecimal areaSize) 
    {
        this.areaSize = areaSize;
    }

    public BigDecimal getAreaSize() 
    {
        return areaSize;
    }
    public void setFloorNum(Long floorNum) 
    {
        this.floorNum = floorNum;
    }

    public Long getFloorNum() 
    {
        return floorNum;
    }
    public void setDepartment(String department) 
    {
        this.department = department;
    }

    public String getDepartment() 
    {
        return department;
    }
    public void setPersonnelCount(Long personnelCount) 
    {
        this.personnelCount = personnelCount;
    }

    public Long getPersonnelCount() 
    {
        return personnelCount;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("parentAreaId", getParentAreaId())
            .append("ancestors", getAncestors())
            .append("buildingId", getBuildingId())
            .append("areaCode", getAreaCode())
            .append("areaName", getAreaName())
            .append("areaType", getAreaType())
            .append("areaSize", getAreaSize())
            .append("floorNum", getFloorNum())
            .append("department", getDepartment())
            .append("personnelCount", getPersonnelCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
