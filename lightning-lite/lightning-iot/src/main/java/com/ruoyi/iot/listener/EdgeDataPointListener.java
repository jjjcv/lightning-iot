package com.ruoyi.iot.listener;

import cn.idev.excel.context.AnalysisContext;
import cn.idev.excel.event.AnalysisEventListener;
import cn.idev.excel.metadata.data.ReadCellData;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.PropertyMetadata;
import com.ruoyi.iot.metadata.ValueTypeTranslator;
import com.ruoyi.iot.protocol.ProtocolThingsMetadata;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;

@Slf4j
@Data
public class EdgeDataPointListener extends AnalysisEventListener<Map<Integer, String>> {

    private ProtocolThingsMetadata protocolThingsMetadata;

    private List<EdgeDataPoint> edgeDataPointList;

    private boolean hasDataPointIdColumn;

    @Override
    public void invokeHead(Map<Integer, ReadCellData<?>> headMap, AnalysisContext context) {
        ReadCellData<?> firstHead = headMap.get(0);
        hasDataPointIdColumn = firstHead != null
            && ("数据点位ID".equals(firstHead.getStringValue()) || "id".equalsIgnoreCase(firstHead.getStringValue()));
        log.info("解析到表头数据: {}", JSON.toJSONString(headMap));
    }

    @Override
    public void invoke(Map<Integer, String> data, AnalysisContext analysisContext) {

        List<PropertyMetadata> dataPointProperties = protocolThingsMetadata.getDataPointProperties();

        EdgeDataPoint edgeDataPoint = new EdgeDataPoint();
        int baseIndex = hasDataPointIdColumn ? 1 : 0;
        edgeDataPoint.setName(data.get(baseIndex));
        edgeDataPoint.setProtocolId(data.get(baseIndex + 1));
        edgeDataPoint.setGatewayId(data.get(baseIndex + 2));
        edgeDataPoint.setType(data.get(baseIndex + 3));
        edgeDataPoint.setOperationTpye(data.get(baseIndex + 4));

        int index = baseIndex + 5;
        JSONObject configJson = new JSONObject();
        for (PropertyMetadata propertyMetadata : dataPointProperties) {
            String dataString = data.get(index);
            DataType dataType = propertyMetadata.getValueType();
            Object translatorValue = ValueTypeTranslator.translator(dataString, dataType);
            configJson.put(propertyMetadata.getId(), translatorValue);
            index++;
        }

        edgeDataPoint.setConfig(configJson.toJSONString());
        log.info("读取到一条数据: {}", JSON.toJSONString(data));
        edgeDataPointList.add(edgeDataPoint);
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        log.info("所有数据读取完成，共 {} 条！", edgeDataPointList.size());
    }

}
