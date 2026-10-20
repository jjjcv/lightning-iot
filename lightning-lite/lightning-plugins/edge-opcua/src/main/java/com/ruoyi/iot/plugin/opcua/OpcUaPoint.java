package com.ruoyi.iot.plugin.opcua;

import com.alibaba.fastjson2.annotation.JSONField;
import org.eclipse.milo.opcua.stack.core.types.builtin.NodeId;

/** 单个 OPC UA 点位的协议配置。 */
public class OpcUaPoint {

    private String id;

    @JSONField(name = "nodeId", alternateNames = {"node_id"})
    private String nodeId;

    private String browseName;

    private String displayName;

    private String dataType;

    private String dataTypeNodeId;

    private String accessLevel;

    private boolean writable;

    /** 平台点位类型，仅供写值转换使用，不属于 OPC UA 点位协议配置。 */
    @JSONField(serialize = false, deserialize = false)
    private String platformDataType;

    public NodeId parseNodeId() {
        if (nodeId == null || nodeId.isBlank()) {
            throw new IllegalArgumentException("nodeId 不能为空");
        }
        return NodeId.parse(nodeId.trim());
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNodeId() {
        return nodeId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    public String getBrowseName() {
        return browseName;
    }

    public void setBrowseName(String browseName) {
        this.browseName = browseName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getDataTypeNodeId() {
        return dataTypeNodeId;
    }

    public void setDataTypeNodeId(String dataTypeNodeId) {
        this.dataTypeNodeId = dataTypeNodeId;
    }

    public String getAccessLevel() {
        return accessLevel;
    }

    public void setAccessLevel(String accessLevel) {
        this.accessLevel = accessLevel;
    }

    public boolean isWritable() {
        return writable;
    }

    public void setWritable(boolean writable) {
        this.writable = writable;
    }

    public String getPlatformDataType() {
        return platformDataType;
    }

    public void setPlatformDataType(String platformDataType) {
        this.platformDataType = platformDataType;
    }

}
