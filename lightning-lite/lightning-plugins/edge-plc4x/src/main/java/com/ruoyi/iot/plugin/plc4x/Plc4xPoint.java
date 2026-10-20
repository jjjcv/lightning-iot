package com.ruoyi.iot.plugin.plc4x;

import com.alibaba.fastjson2.annotation.JSONField;

public class Plc4xPoint {

    private String id;

    @JSONField(name = "tag_address")
    private String tagAddress;

    @JSONField(name = "subscription_type")
    private String subscriptionType;

    @JSONField(name = "subscription_interval")
    private Integer subscriptionInterval;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTagAddress() {
        return tagAddress;
    }

    public void setTagAddress(String tagAddress) {
        this.tagAddress = tagAddress;
    }

    public String getSubscriptionType() {
        return subscriptionType;
    }

    public void setSubscriptionType(String subscriptionType) {
        this.subscriptionType = subscriptionType;
    }

    public Integer getSubscriptionInterval() {
        return subscriptionInterval;
    }

    public void setSubscriptionInterval(Integer subscriptionInterval) {
        this.subscriptionInterval = subscriptionInterval;
    }
}
