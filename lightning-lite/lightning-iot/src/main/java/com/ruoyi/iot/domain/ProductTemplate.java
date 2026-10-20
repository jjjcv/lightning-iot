package com.ruoyi.iot.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 产品物模型对象 product_templates
 * 
 * @author ruoyi
 * @date 2025-02-25
 */
@Schema(description = "产品物模型对象 product_templates") // 类级注解
public class ProductTemplate extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**  */
    @Schema(description = "主键ID")
    private String id;

    /** 产品Id */
    @Excel(name = "产品Id")
    @Schema(description = "产品ID")
    private String productId;

    /** 模型归类：property，function，event */
    @Excel(name = "模型归类：property，function，event")
    @Schema(description = "模型归类：property-属性，function-功能，event-事件")
    private String classify;

    /** 名称 */
    @Excel(name = "名称")
    @Schema(description = "模型名称")
    private String name;

    /** 标识 */
    @Excel(name = "标识")
    @Schema(description = "模型标识")
    private String telemetryKey;

    /** 属性说明 */
    @Excel(name = "属性说明")
    @Schema(description = "模型说明")
    private String description;

    /** 数据类型 */
    @Excel(name = "数据类型")
    @Schema(description = "数据类型")
    private String type;

    /** 读写类型：r读，w写，p上报 */
    @Excel(name = "读写类型：r读，w写，p上报")
    @Schema(description = "读写类型：r-读，w-写，p-上报")
    private String operationTpye; // 注意字段名拼写（原类中拼写为 operationTpye）

    /** 数据定义 */
    @Excel(name = "数据定义")
    @Schema(description = "数据定义")
    private String define;

    public void setId(String id) 
    {
        this.id = id;
    }

    public String getId() 
    {
        return id;
    }
    public void setProductId(String productId) 
    {
        this.productId = productId;
    }

    public String getProductId() 
    {
        return productId;
    }
    public void setClassify(String classify) 
    {
        this.classify = classify;
    }

    public String getClassify() 
    {
        return classify;
    }
    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }
    public void setTelemetryKey(String telemetryKey) 
    {
        this.telemetryKey = telemetryKey;
    }

    public String getTelemetryKey() 
    {
        return telemetryKey;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
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
    public void setDefine(String define) 
    {
        this.define = define;
    }

    public String getDefine() 
    {
        return define;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("productId", getProductId())
            .append("classify", getClassify())
            .append("name", getName())
            .append("telemetryKey", getTelemetryKey())
            .append("description", getDescription())
            .append("type", getType())
            .append("operationTpye", getOperationTpye())
            .append("define", getDefine())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
