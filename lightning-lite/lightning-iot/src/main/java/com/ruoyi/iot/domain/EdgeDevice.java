package com.ruoyi.iot.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.iot.edge.EdgeDeviceConfig;

/**
 * 设备接入网关对象 edge_device
 *
 * @author ruoyi
 * @date 2025-02-14
 */
@Schema(description = "设备接入网关对象 edge_device") // 类级注解
public class EdgeDevice extends BaseEntity implements EdgeDeviceConfig {
    private static final long serialVersionUID = 1L;

    /** id */
    @Schema(description = "主键ID")
    private String id;

    /** 名称 */
    @Excel(name = "名称")
    @Schema(description = "网关名称")
    private String name;

    /** 启停状态：enable，disable */
    @Excel(name = "启停状态：enable，disable")
    @Schema(description = "启停状态：enable-启用，disable-停用")
    private String status;

    /** 连接状态: online, offline */
    @Excel(name = "连接状态: online, offline")
    @Schema(description = "连接状态：online-在线，offline-离线")
    private String linkStatus;

    /** 传输协议id */
    @Excel(name = "传输协议id")
    @Schema(description = "传输协议ID")
    private String protocolId;

    /** 配置信息 */
    @Excel(name = "配置信息")
    @Schema(description = "配置信息")
    private String configuration;

    /** 说明 */
    @Excel(name = "说明")
    @Schema(description = "说明信息")
    private String description;

    /** 状态变更时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "状态变更时间")
    private Date statusTime;

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
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setLinkStatus(String linkStatus) 
    {
        this.linkStatus = linkStatus;
    }

    public String getLinkStatus() 
    {
        return linkStatus;
    }
    public void setProtocolId(String protocolId) 
    {
        this.protocolId = protocolId;
    }

    public String getProtocolId() 
    {
        return protocolId;
    }
    public void setConfiguration(String configuration) 
    {
        this.configuration = configuration;
    }

    public String getConfiguration() 
    {
        return configuration;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
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
            .append("status", getStatus())
            .append("linkStatus", getLinkStatus())
            .append("protocolId", getProtocolId())
            .append("configuration", getConfiguration())
            .append("description", getDescription())
            .append("statusTime", getStatusTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
