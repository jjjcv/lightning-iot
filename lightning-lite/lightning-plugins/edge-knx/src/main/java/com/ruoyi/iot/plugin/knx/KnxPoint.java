package com.ruoyi.iot.plugin.knx;

import com.alibaba.fastjson2.annotation.JSONField;
import io.calimero.GroupAddress;
import io.calimero.datapoint.StateDP;
import io.calimero.dptxlator.DptId;

/** 单个 KNX 组对象点位的协议配置。 */
public class KnxPoint {

    private String id;

    @JSONField(name = "groupAddress")
    private String groupAddress;

    private String dpt;

    private transient GroupAddress parsedAddress;
    private transient StateDP datapoint;

    public void validateAndPrepare(String name) throws Exception {
        if (groupAddress == null || groupAddress.isBlank()) {
            throw new IllegalArgumentException("groupAddress 不能为空");
        }
        if (dpt == null || dpt.isBlank()) {
            throw new IllegalArgumentException("dpt 不能为空");
        }
        parsedAddress = new GroupAddress(groupAddress.trim());
        DptId dptId = DptId.from(dpt.trim());
        dpt = dptId.toString();
        datapoint = new StateDP(parsedAddress, name == null ? parsedAddress.toString() : name, dptId);
    }

    public int rawAddress() {
        if (parsedAddress == null) {
            throw new IllegalStateException("KNX 点位尚未初始化");
        }
        return parsedAddress.getRawAddress();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGroupAddress() {
        return groupAddress;
    }

    public void setGroupAddress(String groupAddress) {
        this.groupAddress = groupAddress;
    }

    public String getDpt() {
        return dpt;
    }

    public void setDpt(String dpt) {
        this.dpt = dpt;
    }

    public GroupAddress getParsedAddress() {
        return parsedAddress;
    }

    public StateDP getDatapoint() {
        return datapoint;
    }
}
