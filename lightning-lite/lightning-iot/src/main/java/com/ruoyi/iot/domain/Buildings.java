package com.ruoyi.iot.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.math.BigDecimal;

/**
 * 建筑基础信息对象 buildings
 * 
 * @author ruoyi
 * @date 2025-08-26
 */
@Schema(description = "建筑基础信息对象 buildings")
public class Buildings extends BaseEntity {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "建筑编码")
    @Excel(name = "建筑编码")
    private String buildingCode;

    @Schema(description = "建筑名称")
    @Excel(name = "建筑名称")
    private String buildingName;

    @Schema(description = "建筑类型")
    @Excel(name = "建筑类型")
    private String buildingType;

    @Schema(description = "总面积(m²)", example = "1000.00")
    @Excel(name = "总面积(m²)")
    private BigDecimal totalArea;

    @Schema(description = "楼层数", example = "10")
    @Excel(name = "楼层数")
    private Long floors;

    @Schema(description = "建成年份", example = "2020")
    @Excel(name = "建成年份")
    private Long constructionYear;

    @Schema(description = "地理位置")
    @Excel(name = "地理位置")
    private String location;

    @Schema(description = "结构形式")
    @Excel(name = "结构形式")
    private String buildingStructure;

    @Schema(description = "外墙保温形式")
    @Excel(name = "外墙保温形式")
    private String exteriorWallInsulationType;

    @Schema(description = "屋面保温形式")
    @Excel(name = "屋面保温形式")
    private String roofInsulationType;

    @Schema(description = "外窗类型")
    @Excel(name = "外窗类型")
    private String windowType;

    @Schema(description = "玻璃类型")
    @Excel(name = "玻璃类型")
    private String glassType;

    @Schema(description = "空调覆盖面积 m2", example = "500.00")
    @Excel(name = "空调覆盖面积 m2")
    private BigDecimal airConditioningArea;

    @Schema(description = "空调形式")
    @Excel(name = "空调形式")
    private String airConditioningType;

    private String climateZone;
    private Long personnelCount;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setBuildingCode(String buildingCode) 
    {
        this.buildingCode = buildingCode;
    }

    public String getBuildingCode() 
    {
        return buildingCode;
    }
    public void setBuildingName(String buildingName) 
    {
        this.buildingName = buildingName;
    }

    public String getBuildingName() 
    {
        return buildingName;
    }
    public void setBuildingType(String buildingType) 
    {
        this.buildingType = buildingType;
    }

    public String getBuildingType() 
    {
        return buildingType;
    }
    public void setTotalArea(BigDecimal totalArea) 
    {
        this.totalArea = totalArea;
    }

    public BigDecimal getTotalArea() 
    {
        return totalArea;
    }
    public void setFloors(Long floors) 
    {
        this.floors = floors;
    }

    public Long getFloors() 
    {
        return floors;
    }
    public void setConstructionYear(Long constructionYear) 
    {
        this.constructionYear = constructionYear;
    }

    public Long getConstructionYear() 
    {
        return constructionYear;
    }
    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }
    public void setBuildingStructure(String buildingStructure) 
    {
        this.buildingStructure = buildingStructure;
    }

    public String getBuildingStructure() 
    {
        return buildingStructure;
    }
    public void setExteriorWallInsulationType(String exteriorWallInsulationType) 
    {
        this.exteriorWallInsulationType = exteriorWallInsulationType;
    }

    public String getExteriorWallInsulationType() 
    {
        return exteriorWallInsulationType;
    }
    public void setRoofInsulationType(String roofInsulationType) 
    {
        this.roofInsulationType = roofInsulationType;
    }

    public String getRoofInsulationType() 
    {
        return roofInsulationType;
    }
    public void setWindowType(String windowType) 
    {
        this.windowType = windowType;
    }

    public String getWindowType() 
    {
        return windowType;
    }
    public void setGlassType(String glassType) 
    {
        this.glassType = glassType;
    }

    public String getGlassType() 
    {
        return glassType;
    }
    public void setAirConditioningArea(BigDecimal airConditioningArea) 
    {
        this.airConditioningArea = airConditioningArea;
    }

    public BigDecimal getAirConditioningArea() 
    {
        return airConditioningArea;
    }
    public void setAirConditioningType(String airConditioningType) 
    {
        this.airConditioningType = airConditioningType;
    }

    public String getAirConditioningType() 
    {
        return airConditioningType;
    }
    public String getClimateZone() { return climateZone; }
    public void setClimateZone(String climateZone) { this.climateZone = climateZone; }
    public Long getPersonnelCount() { return personnelCount; }
    public void setPersonnelCount(Long personnelCount) { this.personnelCount = personnelCount; }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("buildingCode", getBuildingCode())
            .append("buildingName", getBuildingName())
            .append("buildingType", getBuildingType())
            .append("totalArea", getTotalArea())
            .append("floors", getFloors())
            .append("constructionYear", getConstructionYear())
            .append("location", getLocation())
            .append("buildingStructure", getBuildingStructure())
            .append("exteriorWallInsulationType", getExteriorWallInsulationType())
            .append("roofInsulationType", getRoofInsulationType())
            .append("windowType", getWindowType())
            .append("glassType", getGlassType())
            .append("airConditioningArea", getAirConditioningArea())
            .append("airConditioningType", getAirConditioningType())
            .append("climateZone", getClimateZone())
            .append("personnelCount", getPersonnelCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
