package com.ruoyi.iot.domain;

import lombok.Data;

@Data
public class PartitionStrategy {

    private String tableName;
    private String partitionType; // RANGE, LIST, HASH
    private String partitionColumn;
    private String timeUnit; // MONTH, DAY, YEAR
    private Integer retentionMonths; // 数据保留月数
    private Integer preCreateMonths; // 预创建分区月数

}
