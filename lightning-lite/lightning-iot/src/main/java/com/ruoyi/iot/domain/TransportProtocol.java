package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 传输协议对象 transport_protocol
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
@Schema(description = "传输协议对象 transport_protocol") // 类级注解
public class TransportProtocol extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @Excel(name = "id")
    @Schema(description = "主键ID")
    private String id;

    /** 传输协议名称 */
    @Excel(name = "传输协议名称")
    @Schema(description = "传输协议名称")
    private String name;

    /** 协议描述 */
    @Excel(name = "协议描述")
    @Schema(description = "协议描述")
    private String description;

    /** 启停状态 */
    @Excel(name = "启停状态")
    @Schema(description = "启停状态（enable-启用，disable-停用）")
    private String status;

    /** 传输协议配置 */
    @Excel(name = "传输协议配置")
    @Schema(description = "传输协议配置")
    private String configuration;

    /** 传输协议类型 */
    @Excel(name = "传输协议类型")
    @Schema(description = "传输协议类型")
    private String protocolType;

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
    public void setConfiguration(String configuration) 
    {
        this.configuration = configuration;
    }

    public String getConfiguration() 
    {
        return configuration;
    }
    public void setProtocolType(String protocolType) 
    {
        this.protocolType = protocolType;
    }

    public String getProtocolType() 
    {
        return protocolType;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("configuration", getConfiguration())
            .append("protocolType", getProtocolType())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
