package com.ruoyi.iot.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.iot.util.TagUtils;
import java.util.List;
import java.util.ArrayList;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Date;

/**
 * 设备对象 devices
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@Schema(description = "设备对象 devices") // 类注解
public class Device extends BaseEntity implements TaggedObject {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @Excel(name = "设备ID")
    private String id;

    @Schema(description = "设备名称")
    @Excel(name = "设备名称")
    private String name;

    @Schema(description = "设备token")
    @Excel(name = "设备token")
    private String token;

    @Schema(description = "设备别名")
    @Excel(name = "设备别名")
    private String alias;

    @Schema(description = "产品Id")
    @Excel(name = "产品Id")
    private String productId;

    @Schema(description = "产品说明")
    @Excel(name = "产品说明")
    private String description;

    @Schema(description = "启停状态：enable，disable")
    private String status;

    @Schema(description = "拓展，json格式")
    @Excel(name = "拓展，json格式")
    private String ext;

    @Schema(description = "所属网关设备id")
    @Excel(name = "所属网关设备id")
    private String gatewayId;

    @Schema(description = "设备类型：direct、gateway、gatewayS")
    @Excel(name = "设备类型：direct、gateway、gatewayS")
    private String deviceType;

    @Schema(description = "连接状态")
    private String linkStatus;

    @Schema(description = "状态变更时间", example = "2025-02-25 14:30:00")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date statusTime;

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
    public void setToken(String token) 
    {
        this.token = token;
    }

    public String getToken() 
    {
        return token;
    }
    public void setAlias(String alias) 
    {
        this.alias = alias;
    }

    public String getAlias() 
    {
        return alias;
    }
    public void setProductId(String productId) 
    {
        this.productId = productId;
    }

    public String getProductId() 
    {
        return productId;
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
    public void setExt(String ext) 
    {
        this.ext = ext;
    }

    public String getExt() 
    {
        return ext;
    }
    public void setGatewayId(String gatewayId) 
    {
        this.gatewayId = gatewayId;
    }

    public String getGatewayId() 
    {
        return gatewayId;
    }
    public void setDeviceType(String deviceType) 
    {
        this.deviceType = deviceType;
    }

    public String getDeviceType() 
    {
        return deviceType;
    }
    public void setLinkStatus(String linkStatus) 
    {
        this.linkStatus = linkStatus;
    }

    public String getLinkStatus() 
    {
        return linkStatus;
    }
    public void setStatusTime(Date statusTime) 
    {
        this.statusTime = statusTime;
    }

    public Date getStatusTime() 
    {
        return statusTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("token", getToken())
            .append("alias", getAlias())
            .append("productId", getProductId())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("ext", getExt())
            .append("gatewayId", getGatewayId())
            .append("deviceType", getDeviceType())
            .append("linkStatus", getLinkStatus())
            .append("statusTime", getStatusTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
