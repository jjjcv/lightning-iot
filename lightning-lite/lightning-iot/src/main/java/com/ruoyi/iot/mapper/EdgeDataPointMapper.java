package com.ruoyi.iot.mapper;

import java.util.List;
import com.ruoyi.iot.domain.EdgeDataPoint;
import com.ruoyi.iot.domain.EdgeDataPointStatistics;
import org.apache.ibatis.annotations.Param;

/**
 * 网关数据点位Mapper接口
 *
 * @author ruoyi
 * @date 2025-02-14
 */
public interface EdgeDataPointMapper
{

    int deleteByGatewayId(@Param("gatewayId") String gatewayId);

    /**
     * 网关数据点位统计：总数、所属网关在线、所属网关离线
     *
     * @return 网关数据点位统计结果
     */
    public EdgeDataPointStatistics selectEdgeDataPointStatistics();

    /**
     * 查询网关数据点位
     * 
     * @param id 网关数据点位主键
     * @return 网关数据点位
     */
    public EdgeDataPoint selectEdgeDataPointById(String id);

    public EdgeDataPoint selectOneByGatewayIdAndName(@Param("gatewayId") String gatewayId, @Param("name") String name);

    /**
     * 查询网关数据点位列表
     * 
     * @param edgeDataPoint 网关数据点位
     * @return 网关数据点位集合
     */
    public List<EdgeDataPoint> selectEdgeDataPointList(EdgeDataPoint edgeDataPoint);

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
     * 删除网关数据点位
     * 
     * @param id 网关数据点位主键
     * @return 结果
     */
    public int deleteEdgeDataPointById(String id);

    /**
     * 批量删除网关数据点位
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteEdgeDataPointByIds(String[] ids);

    public void updateValueBatchById(@Param("edgeDataPointList") List<EdgeDataPoint> edgeDataPointList);
}
