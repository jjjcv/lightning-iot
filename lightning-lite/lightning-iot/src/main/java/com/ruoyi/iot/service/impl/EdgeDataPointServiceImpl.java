package com.ruoyi.iot.service.impl;

import cn.hutool.core.lang.Snowflake;
import cn.hutool.core.util.IdUtil;
import cn.idev.excel.FastExcel;
import cn.idev.excel.util.ListUtils;
import cn.idev.excel.write.handler.CellWriteHandler;
import cn.idev.excel.write.handler.SheetWriteHandler;
import cn.idev.excel.write.handler.context.CellWriteHandlerContext;
import cn.idev.excel.write.metadata.holder.WriteSheetHolder;
import cn.idev.excel.write.metadata.holder.WriteWorkbookHolder;
import cn.idev.excel.write.style.column.LongestMatchColumnWidthStyleStrategy;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.bean.BeanValidators;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDataPointStatistics;
import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.domain.TransportProtocol;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.listener.EdgeDataPointListener;
import com.ruoyi.iot.mapper.EdgeDataPointMapper;
import com.ruoyi.iot.metadata.PropertyMetadata;
import com.ruoyi.iot.protocol.ProtocolThingsMetadata;
import com.ruoyi.iot.service.IEdgeDataPointService;
import com.ruoyi.iot.service.IEdgeDeviceService;
import com.ruoyi.iot.service.ITransportProtocolService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Validator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 网关数据点位Service业务层处理
 *
 * @author ruoyi
 * @date 2025-02-14
 */
@Service
@Slf4j
public class EdgeDataPointServiceImpl implements IEdgeDataPointService {

    @Autowired
    private EdgeDataPointMapper edgeDataPointMapper;

    @Autowired
    private ITransportProtocolService transportProtocolService;

    @Lazy
    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    protected Validator validator;

    @Autowired
    private RedisTemplate redisTemplate;

    //异步
    @Async("virtualThreadExecutor")
    @Override
    public void updateValueBatchById(List<DataPoint> dataPointList) {

        List<EdgeDataPoint> edgeDataPointList = dataPointList.stream().map(dataPoint -> {
            EdgeDataPoint edgeDataPoint = new EdgeDataPoint();
            edgeDataPoint.setId(dataPoint.getId());
            edgeDataPoint.setValue(String.valueOf(dataPoint.getValue()));
            edgeDataPoint.setLastTime(dataPoint.getLastTime());
            return edgeDataPoint;
        }).collect(Collectors.toList());

        int batchSize = 1000;
        for (int i = 0; i < edgeDataPointList.size(); i += batchSize) {
            List<EdgeDataPoint> batchList = edgeDataPointList.subList(i, Math.min(i + batchSize, edgeDataPointList.size()));
            edgeDataPointMapper.updateValueBatchById(batchList);
        }
    }


    //异步
    @Async("virtualThreadExecutor")
    @Override
    public void updateValueRedisBatchById(List<DataPoint> dataPointList) {

        List<EdgeDataPoint> edgeDataPointList = dataPointList.stream().map(dataPoint -> {
            EdgeDataPoint edgeDataPoint = new EdgeDataPoint();
            edgeDataPoint.setId(dataPoint.getId());
            edgeDataPoint.setValue(String.valueOf(dataPoint.getValue()));
            edgeDataPoint.setLastTime(dataPoint.getLastTime());
            return edgeDataPoint;
        }).collect(Collectors.toList());

        // Redis pipeline 批量写入对象
        redisTemplate.executePipelined((RedisCallback<Object>) connection -> {
            for (EdgeDataPoint dp : edgeDataPointList) {
                String key = "edge:dataPoint:" + dp.getId();
                redisTemplate.opsForValue().set(key, dp);
            }
            return null;
        });

    }

    @Override
    public EdgeDataPoint getEdgeDataPoint(String id) {
        String key = "edge:dataPoint:" + id;
        return (EdgeDataPoint) redisTemplate.opsForValue().get(key);
    }

    @Override
    public Map<String, EdgeDataPoint> getDataPointsBatchAsMap(List<String> ids) {

        List<Object> rawResults = redisTemplate.executePipelined((RedisCallback<Object>) connection -> {
            for (String id : ids) {
                String key = "edge:dataPoint:" + id;
                connection.get(key.getBytes(StandardCharsets.UTF_8));
            }
            return null;
        });

        Map<String, EdgeDataPoint> result = new HashMap<>();

        for (int i = 0; i < rawResults.size(); i++) {
            Object value = rawResults.get(i);
            if (value != null) {
                result.put(ids.get(i), (EdgeDataPoint) value);
            }
        }

        return result;
    }


    @Override
    public int deleteByGatewayId(String gatewayId){
        assertGatewayStopped(gatewayId, "删除");
        return edgeDataPointMapper.deleteByGatewayId(gatewayId);
    }


    /**
     * 查询网关数据点位
     *
     * @param id 网关数据点位主键
     * @return 网关数据点位
     */
    @Override
    public EdgeDataPoint selectEdgeDataPointById(String id) {
        return edgeDataPointMapper.selectEdgeDataPointById(id);
    }


    @Override
    public List<EdgeDataPoint> selectEdgeDataPointListByEdgeId(String edgeId) {
        EdgeDataPoint edgeDataPoint = new EdgeDataPoint();
        edgeDataPoint.setGatewayId(edgeId);
        return edgeDataPointMapper.selectEdgeDataPointList(edgeDataPoint);
    }

    /**
     * 查询网关数据点位列表
     *
     * @param edgeDataPoint 网关数据点位
     * @return 网关数据点位
     */
    @Override
    public List<EdgeDataPoint> selectEdgeDataPointList(EdgeDataPoint edgeDataPoint) {
        return edgeDataPointMapper.selectEdgeDataPointList(edgeDataPoint);
    }

    /**
     * 网关数据点位统计：总数、所属网关在线、所属网关离线
     *
     * @return 网关数据点位统计结果
     */
    @Override
    public EdgeDataPointStatistics selectEdgeDataPointStatistics() {
        return edgeDataPointMapper.selectEdgeDataPointStatistics();
    }



    @Override
    public List<EdgeDataPoint> readEdgeDataPointExcel(MultipartFile file, String gatewayId) throws IOException {

        EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(gatewayId);
        TransportProtocol transportProtocol = transportProtocolService.selectTransportProtocolById(edgeDevice.getProtocolId());
        String configuration = transportProtocol.getConfiguration();
        ProtocolThingsMetadata protocolThingsMetadata = new ProtocolThingsMetadata(configuration);
        List<EdgeDataPoint> edgeDataPointList = new ArrayList<>();
        EdgeDataPointListener edgeDataPointListener = new EdgeDataPointListener();
        edgeDataPointListener.setEdgeDataPointList(edgeDataPointList);
        edgeDataPointListener.setProtocolThingsMetadata(protocolThingsMetadata);
        FastExcel.read(file.getInputStream(), edgeDataPointListener).doReadAll();

        return edgeDataPointList;
    }

    /**
     * 导出网关数据点位列表
     *
     * @param edgeDataPoint 网关数据点位
     * @return 网关数据点位
     */
    @Override
    public void export(HttpServletResponse response, EdgeDataPoint edgeDataPoint) throws IOException {

        EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(edgeDataPoint.getGatewayId());
        TransportProtocol transportProtocol = transportProtocolService.selectTransportProtocolById(edgeDevice.getProtocolId());
        String configuration = transportProtocol.getConfiguration();
        ProtocolThingsMetadata protocolThingsMetadata = new ProtocolThingsMetadata(configuration);

        List<EdgeDataPoint> edgeDataPointList = selectEdgeDataPointList(edgeDataPoint);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("demo", "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        FastExcel.write(response.getOutputStream())
                .registerWriteHandler(new LongestMatchColumnWidthStyleStrategy())
                // 这里放入动态头
                .head(head(protocolThingsMetadata.getDataPointProperties()))
                .sheet("sheet1")
                // 当然这里数据也可以用 List<List<String>> 去传入
                .doWrite(data(edgeDataPointList, protocolThingsMetadata.getDataPointProperties()));
    }

    private List<List<String>> head(List<PropertyMetadata> dataPointProperties) {
        List<List<String>> list = ListUtils.newArrayList();
        List<String> head0 = ListUtils.newArrayList();
        head0.add("数据点位ID");
        list.add(head0);

        List<String> head1 = ListUtils.newArrayList();
        head1.add("数据点位名称");
        list.add(head1);

        List<String> head2 = ListUtils.newArrayList();
        head2.add("协议ID");
        list.add(head2);

        List<String> head3 = ListUtils.newArrayList();
        head3.add("边缘网关设备ID");
        list.add(head3);

        List<String> head4 = ListUtils.newArrayList();
        head4.add("数据类型");
        list.add(head4);

        List<String> head5 = ListUtils.newArrayList();
        head5.add("读写类型");
        list.add(head5);

        for (PropertyMetadata dataPointProperty : dataPointProperties) {
            List<String> head = ListUtils.newArrayList();
            head.add(dataPointProperty.getName());
            list.add(head);
        }


        return list;
    }

    private List<List<String>> data(List<EdgeDataPoint> edgeDataPointList, List<PropertyMetadata> dataPointProperties) {
        List<List<String>> list = ListUtils.newArrayList();

        for (EdgeDataPoint edgeDataPoint : edgeDataPointList) {
            List<String> data = ListUtils.newArrayList();

            data.add(edgeDataPoint.getId());
            data.add(edgeDataPoint.getName());
            data.add(edgeDataPoint.getProtocolId());
            data.add(edgeDataPoint.getGatewayId());
            data.add(edgeDataPoint.getType());
            data.add(edgeDataPoint.getOperationTpye());

            String config = edgeDataPoint.getConfig();
            JSONObject jsonObject = JSON.parseObject(config);
            for(PropertyMetadata dataPointProperty : dataPointProperties){
                data.add(jsonObject.getString(dataPointProperty.getId()));
            }
            list.add(data);
        }



        return list;
    }

    /**
     * 新增网关数据点位
     *
     * @param edgeDataPoint 网关数据点位
     * @return 结果
     */
    @Override
    public int insertEdgeDataPoint(EdgeDataPoint edgeDataPoint) {
        edgeDataPoint.setCreateTime(DateUtils.getNowDate());
        return edgeDataPointMapper.insertEdgeDataPoint(edgeDataPoint);
    }

    /**
     * 修改网关数据点位
     *
     * @param edgeDataPoint 网关数据点位
     * @return 结果
     */
    @Override
    public int updateEdgeDataPoint(EdgeDataPoint edgeDataPoint) {
        EdgeDataPoint existing = edgeDataPointMapper.selectEdgeDataPointById(edgeDataPoint.getId());
        if (existing == null) {
            throw new ServiceException("数据点位不存在：" + edgeDataPoint.getId());
        }
        assertGatewayStopped(existing.getGatewayId(), "修改");
        if (StringUtils.isNotEmpty(edgeDataPoint.getGatewayId())
                && !Objects.equals(existing.getGatewayId(), edgeDataPoint.getGatewayId())) {
            assertGatewayStopped(edgeDataPoint.getGatewayId(), "修改");
        }
        edgeDataPoint.setUpdateTime(DateUtils.getNowDate());
        return edgeDataPointMapper.updateEdgeDataPoint(edgeDataPoint);
    }

    /**
     * 批量删除网关数据点位
     *
     * @param ids 需要删除的网关数据点位主键
     * @return 结果
     */
    @Override
    public int deleteEdgeDataPointByIds(String[] ids) {
        for (String id : ids) {
            EdgeDataPoint edgeDataPoint = edgeDataPointMapper.selectEdgeDataPointById(id);
            if (edgeDataPoint != null) {
                assertGatewayStopped(edgeDataPoint.getGatewayId(), "删除");
            }
        }
        return edgeDataPointMapper.deleteEdgeDataPointByIds(ids);
    }

    /**
     * 删除网关数据点位信息
     *
     * @param id 网关数据点位主键
     * @return 结果
     */
    @Override
    public int deleteEdgeDataPointById(String id) {
        EdgeDataPoint edgeDataPoint = edgeDataPointMapper.selectEdgeDataPointById(id);
        if (edgeDataPoint != null) {
            assertGatewayStopped(edgeDataPoint.getGatewayId(), "删除");
        }
        return edgeDataPointMapper.deleteEdgeDataPointById(id);
    }

    private void assertGatewayStopped(String gatewayId, String operation) {
        EdgeDevice edgeDevice = edgeDeviceService.selectEdgeDeviceById(gatewayId);
        if (edgeDevice == null) {
            throw new ServiceException("网关不存在：" + gatewayId);
        }
        if ("enable".equals(edgeDevice.getStatus())) {
            throw new ServiceException("网关已启动，请先停用网关后再" + operation);
        }
    }

    @Override
    public String importEdgeDataPoint(List<EdgeDataPoint> edgeDataPointList, String gatewayId, boolean isUpdateSupport, String operName) {
        if (StringUtils.isNull(edgeDataPointList) || edgeDataPointList.isEmpty()) {
            throw new ServiceException("导入点位信息不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        Snowflake snowflake = IdUtil.getSnowflake(1, 1);

        for (EdgeDataPoint point : edgeDataPointList) {
            try {

                EdgeDataPoint edgeDataPoint = edgeDataPointMapper.selectOneByGatewayIdAndName(gatewayId, point.getName());
                point.setGatewayId(gatewayId);
                if (edgeDataPoint == null) {
                    BeanValidators.validateWithException(validator, point);
                    point.setId(snowflake.nextIdStr());
                    point.setCreateBy(operName);
                    edgeDataPointMapper.insertEdgeDataPoint(point);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、网关：" + point.getGatewayId() + "，点位:" + point.getName() + " 导入成功");
                } else if (isUpdateSupport) {
                    assertGatewayStopped(gatewayId, "修改");
                    BeanValidators.validateWithException(validator, point);
                    point.setId(edgeDataPoint.getId());
                    point.setUpdateBy(operName);
                    edgeDataPointMapper.updateEdgeDataPoint(point);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、网关：" + point.getGatewayId() + "，点位:" + point.getName() + " 更新成功");
                } else {
                    failureNum++;
                    failureMsg.append("<br/>" + successNum + "、网关：" + point.getGatewayId() + "，点位:" + point.getName() + " 已存在");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + successNum + "、网关：" + point.getGatewayId() + "，点位:" + point.getName() + " 导入失败：";
                failureMsg.append(msg + e.getMessage());
                log.error(msg, e);
            }
        }
        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        return successMsg.toString();
    }

}
