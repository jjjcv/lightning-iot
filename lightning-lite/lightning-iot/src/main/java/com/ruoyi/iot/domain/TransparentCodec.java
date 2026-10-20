package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 透传消息解析器对象 transparent_codec
 * 
 * @author ruoyi
 * @date 2025-02-27
 */
@Schema(description = "透传消息解析器对象 transparent_codec") // 类级注解
public class TransparentCodec extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @Excel(name = "id")
    @Schema(description = "主键ID")
    private String id;

    /** 解析包名称 */
    @Excel(name = "解析包名称")
    @Schema(description = "解析包名称")
    private String name;

    /** 解析包提供商 */
    @Excel(name = "解析包提供商")
    @Schema(description = "解析包提供商")
    private String provider;

    /** 解析包描述 */
    @Excel(name = "解析包描述")
    @Schema(description = "解析包描述")
    private String description;

    /** 通信协议名称 */
    @Excel(name = "通信协议名称")
    @Schema(description = "通信协议ID")
    private String protocolId;

    /** 通信包文件地址 */
    @Excel(name = "通信包文件地址")
    @Schema(description = "通信包文件地址")
    private String fileUrl;

    /** 协议包编解码配置 */
    @Excel(name = "协议包编解码配置")
    @Schema(description = "协议包编解码配置")
    private String configuration;

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
    public void setProvider(String provider) 
    {
        this.provider = provider;
    }

    public String getProvider() 
    {
        return provider;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setProtocolId(String protocolId) 
    {
        this.protocolId = protocolId;
    }

    public String getProtocolId() 
    {
        return protocolId;
    }
    public void setFileUrl(String fileUrl) 
    {
        this.fileUrl = fileUrl;
    }

    public String getFileUrl() 
    {
        return fileUrl;
    }
    public void setConfiguration(String configuration) 
    {
        this.configuration = configuration;
    }

    public String getConfiguration() 
    {
        return configuration;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("provider", getProvider())
            .append("description", getDescription())
            .append("protocolId", getProtocolId())
            .append("fileUrl", getFileUrl())
            .append("configuration", getConfiguration())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
