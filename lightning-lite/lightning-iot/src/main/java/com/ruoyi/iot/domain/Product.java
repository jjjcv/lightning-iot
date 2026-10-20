package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.iot.util.TagUtils;
import java.util.List;
import java.util.ArrayList;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 产品信息对象 products
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@Schema(description = "产品信息对象 products") // 类级注解
public class Product extends BaseEntity implements TaggedObject {
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    @Schema(description = "产品ID")
    private String id;

    /** 产品名称 */
    @Excel(name = "产品名称")
    @Schema(description = "产品名称")
    private String name;

    /** 图片地址 */
    @Excel(name = "图片地址")
    @Schema(description = "图片地址")
    private String photoUrl;

    /** 产品说明 */
    @Excel(name = "产品说明")
    @Schema(description = "产品说明")
    private String description;

    /** 产品类型Id */
    @Excel(name = "产品类型Id")
    @Schema(description = "产品类型ID")
    private Long productCategoryId;

    /** 传输协议id */
    @Excel(name = "传输协议id")
    @Schema(description = "传输协议ID")
    private String protocolId;

    /** 消息解析器 */
    @Excel(name = "消息解析器")
    @Schema(description = "消息解析器ID")
    private String transportCodecId;

    /** 数据存储间隔（ms） */
    @Excel(name = "数据存储间隔", readConverterExp = "m=s")
    @Schema(description = "数据存储间隔（毫秒）")
    private Long storageInterval;

    /** 数据过期时间（ms） */
    @Excel(name = "数据过期时间", readConverterExp = "m=s")
    @Schema(description = "数据过期时间（毫秒）")
    private Long dataExpiration;

    /** 设备类型：direct、gateway、gatewayS */
    @Excel(name = "设备类型：direct、gateway、gatewayS")
    @Schema(description = "设备类型：direct-直连设备，gateway-网关设备，gatewayS-网关子设备")
    private String deviceType;

    /** 启停状态：enable，disable */
    @Excel(name = "启停状态：enable，disable")
    @Schema(description = "启停状态：enable-启用，disable-停用")
    private String status;

    /** 写入时 null 表示保留原标签，空列表表示解除全部标签；查询时用于筛选。 */
    private List<Long> tagIds;
    private String tagMatchMode = "any";
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private List<TagDetail> tags = List.of();

    public List<Long> getTagIds() { return tagIds; }
    public void setTagIds(List<Long> tagIds) {
        this.tagIds = tagIds == null ? null : new ArrayList<>(TagUtils.normalizeIds(tagIds));
    }
    @JsonIgnore
    public List<Long> getTagFilterIds() { return tagIds == null ? null : TagUtils.normalizeIds(tagIds); }
    public String getTagMatchMode() { return tagMatchMode; }
    public void setTagMatchMode(String mode) {
        if (!"any".equals(mode) && !"all".equals(mode)) {
            throw new ServiceException("标签匹配方式仅支持 any 或 all");
        }
        this.tagMatchMode = mode;
    }
    public List<TagDetail> getTags() { return tags; }
    public void setTags(List<TagDetail> tags) {
        this.tags = tags;
    }

    public void setId(String id) 
    {
        this.id = id;
    }

    public String getId() 
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
    public void setPhotoUrl(String photoUrl) 
    {
        this.photoUrl = photoUrl;
    }

    public String getPhotoUrl() 
    {
        return photoUrl;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setProductCategoryId(Long productCategoryId)
    {
        this.productCategoryId = productCategoryId;
    }

    public Long getProductCategoryId()
    {
        return productCategoryId;
    }
    public void setProtocolId(String protocolId) 
    {
        this.protocolId = protocolId;
    }

    public String getProtocolId() 
    {
        return protocolId;
    }
    public void setTransportCodecId(String transportCodecId) 
    {
        this.transportCodecId = transportCodecId;
    }

    public String getTransportCodecId() 
    {
        return transportCodecId;
    }
    public void setStorageInterval(Long storageInterval) 
    {
        this.storageInterval = storageInterval;
    }

    public Long getStorageInterval() 
    {
        return storageInterval;
    }
    public void setDataExpiration(Long dataExpiration) 
    {
        this.dataExpiration = dataExpiration;
    }

    public Long getDataExpiration() 
    {
        return dataExpiration;
    }
    public void setDeviceType(String deviceType) 
    {
        this.deviceType = deviceType;
    }

    public String getDeviceType() 
    {
        return deviceType;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("photoUrl", getPhotoUrl())
            .append("description", getDescription())
            .append("productCategoryId", getProductCategoryId())
            .append("protocolId", getProtocolId())
            .append("transportCodecId", getTransportCodecId())
            .append("storageInterval", getStorageInterval())
            .append("dataExpiration", getDataExpiration())
            .append("deviceType", getDeviceType())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
