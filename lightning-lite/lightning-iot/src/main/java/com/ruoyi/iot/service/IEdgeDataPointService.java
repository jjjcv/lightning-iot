package com.ruoyi.iot.service;


import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDataPointStatistics;

import com.ruoyi.iot.edge.DataPoint;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 网关数据点位Service接口
 * 
 * @author ruoyi
 * @date 2025-02-14
 */
public interface IEdgeDataPointService 
{
    void updateValueBatchById(List<DataPoint> dataPointList);

    //异步
    @Async("virtualThreadExecutor")
    void updateValueRedisBatchById(List<DataPoint> dataPointList);

    EdgeDataPoint getEdgeDataPoint(String id);

    Map<String, EdgeDataPoint> getDataPointsBatchAsMap(List<String> ids);

    int deleteByGatewayId(String gatewayId);

    /**
     * 查询网关数据点位
     * 
     * @param id 网关数据点位主键
     * @return 网关数据点位
     */
    public EdgeDataPoint selectEdgeDataPointById(String id);

    List<EdgeDataPoint> selectEdgeDataPointListByEdgeId(String edgeId);

    /**
     * 查询网关数据点位列表
     * 
     * @param edgeDataPoint 网关数据点位
     * @return 网关数据点位集合
     */
    public List<EdgeDataPoint> selectEdgeDataPointList(EdgeDataPoint edgeDataPoint);

    /**
     * 网关数据点位统计：总数、所属网关在线、所属网关离线
     *
     * @return 网关数据点位统计结果
     */
    public EdgeDataPointStatistics selectEdgeDataPointStatistics();

    List<EdgeDataPoint> readEdgeDataPointExcel(MultipartFile file, String gatewayId) throws IOException;

    void export(HttpServletResponse response, EdgeDataPoint edgeDataPoint) throws IOException;

    /**
     * 新增网关数据点位
     * 
     * @param edgeDataPoint 网关数据点位
     * @return 结果
     */
    public int insertEdgeDataPoint(EdgeDataPoint edgeDataPoint);

    /**
     * 修改网关数据点位
     * 
     * @param edgeDataPoint 网关数据点位
     * @return 结果
     */
    public int updateEdgeDataPoint(EdgeDataPoint edgeDataPoint);

    /**
     * 批量删除网关数据点位
     * 
     * @param ids 需要删除的网关数据点位主键集合
     * @return 结果
     */
    public int deleteEdgeDataPointByIds(String[] ids);

    /**
     * 删除网关数据点位信息
     * 
     * @param id 网关数据点位主键
     * @return 结果
     */
    public int deleteEdgeDataPointById(String id);

    /**
     * 导入网关数据点位数据
     *
     * @param edgeDataPointList
     * @param gatewayId
     * @param isUpdateSupport
     * @param operName
     * @return
     */
    public String importEdgeDataPoint(List<EdgeDataPoint> edgeDataPointList, String gatewayId, boolean isUpdateSupport, String operName);

}
