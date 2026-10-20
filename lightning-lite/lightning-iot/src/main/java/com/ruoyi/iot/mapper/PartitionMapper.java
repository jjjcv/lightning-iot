package com.ruoyi.iot.mapper;


import com.ruoyi.iot.domain.PartitionInfo;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface PartitionMapper {

    /**
     * 查询表的所有分区信息
     */
    List<PartitionInfo> selectPartitionsByTable(@Param("tableName") String tableName);

    /**
     * 检查分区是否存在
     */
    Integer checkPartitionExists(@Param("tableName") String tableName,
                                 @Param("partitionName") String partitionName);

    /**
     * 创建月份分区
     */
    void createMonthPartition(@Param("tableName") String tableName,
                              @Param("partitionName") String partitionName,
                              @Param("partitionValue") String partitionValue);

    /**
     * 创建日分区
     */
    void createDayPartition(@Param("tableName") String tableName,
                            @Param("partitionName") String partitionName,
                            @Param("partitionValue") String partitionValue);

    /**
     * 删除分区
     */
    void dropPartition(@Param("tableName") String tableName,
                       @Param("partitionName") String partitionName);

    /**
     * 查询分区统计信息
     */
    @MapKey("partitionName")
    List<Map<String, Object>> selectPartitionStatistics(@Param("tableName") String tableName);

    /**
     * 获取表的分区类型和表达式
     */
    @MapKey("partitionName")
    Map<String, Object> getTablePartitionInfo(@Param("tableName") String tableName);

    /**
     * 重组分区（删除数据后整理分区）
     */
    void reorganizePartition(@Param("tableName") String tableName,
                             @Param("partitionName") String partitionName);

    /**
     * 分析分区（优化分区性能）
     */
    void analyzePartition(@Param("tableName") String tableName,
                          @Param("partitionName") String partitionName);
}
