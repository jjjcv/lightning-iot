package com.ruoyi.iot.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 网关数据点位对象 edge_data_point
 *
 * @author ruoyi
 * @date 2025-02-19
 */
@Schema(description = "网关数据点位对象 edge_data_point") // 类级注解
public class EdgeDataPoint extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @Excel(name = "id")
    @Schema(description = "主键ID")
    private String id;

    /** 数据点位名称 */
    @Excel(name = "数据点位名称")
    @Schema(description = "数据点位名称")
    private String name;

    /** 协议id */
    @Excel(name = "协议id")
    @Schema(description = "协议ID")
    private String protocolId;

    /** 边缘网关设备id */
    @Excel(name = "边缘网关设备id")
    @Schema(description = "边缘网关设备ID")
    private String gatewayId;

    /** 数据类型：内置数据类型 */
    @Excel(name = "数据类型：内置数据类型")
    @Schema(description = "数据类型（内置数据类型）")
    private String type;

    /** 读写类型：r读，w写，p上报 */
    @Excel(name = "读写类型：r读，w写，p上报")
    @Schema(description = "读写类型：r-读，w-写，p-上报")
    private String operationTpye; // 注意字段名拼写（原类中拼写为 operationTpye）

    /** 属性模板配置（配置对应的网关中的数据点） */
    @Excel(name = "数据点位配置")
    @Schema(description = "属性模板配置（网关数据点关联配置）")
    private String config;

    /** 点位值 */
    @Schema(description = "点位值")
    private String value;

    /** 点位值更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(description = "点位值更新时间")
    private Date lastTime;

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
    public void setProtocolId(String protocolId)
    {
        this.protocolId = protocolId;
    }

    public String getProtocolId()
    {
        return protocolId;
    }
    public void setGatewayId(String gatewayId)
    {
        this.gatewayId = gatewayId;
    }

    public String getGatewayId()
    {
        return gatewayId;
    }
    public void setType(String type)
    {
        this.type = type;
    }

    public String getType()
    {
        return type;
    }
    public void setOperationTpye(String operationTpye)
    {
        this.operationTpye = operationTpye;
    }

    public String getOperationTpye()
    {
        return operationTpye;
    }
    public void setConfig(String config)
    {
        this.config = config;
    }

    public String getConfig()
    {
        return config;
    }
    public void setValue(String value)
    {
        this.value = value;
    }

    public String getValue()
    {
        return value;
    }
    public void setLastTime(Date lastTime)
    {
        this.lastTime = lastTime;
    }

    public Date getLastTime()
    {
        return lastTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("name", getName())
                .append("protocolId", getProtocolId())
                .append("gatewayId", getGatewayId())
                .append("type", getType())
                .append("operationTpye", getOperationTpye())
                .append("config", getConfig())
                .append("value", getValue())
                .append("lastTime", getLastTime())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .toString();
    }
}
