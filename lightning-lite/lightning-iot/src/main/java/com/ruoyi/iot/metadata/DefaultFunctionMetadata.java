package com.ruoyi.iot.metadata;


import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;



@Getter
@Setter
@NoArgsConstructor
public class DefaultFunctionMetadata extends FunctionMetadata{

    private transient JSONObject jsonObject;

    public DefaultFunctionMetadata(JSONObject jsonObject) {
        fromJson(jsonObject);
    }


    @Override
    public JSONObject toJson() {

        return (JSONObject) JSON.toJSON(this);

    }

    @Override
    public void fromJson(JSONObject json) {
        this.jsonObject = json;
        this.id = json.getString("id");
        this.name = json.getString("name");
        this.description = json.getString("description");
        this.expands = json.getJSONObject("expands");

    }




}
