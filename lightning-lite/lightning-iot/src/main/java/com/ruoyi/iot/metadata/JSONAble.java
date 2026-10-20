package com.ruoyi.iot.metadata;

import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.BeanUtils;

public interface JSONAble {


    default JSONObject toJson() {
        JSONObject jsonObject = new JSONObject();
        BeanUtils.copyProperties(this,jsonObject);
        return jsonObject;
    }

    default void fromJson(JSONObject json) {
        BeanUtils.copyProperties(json, this);
    }

}
