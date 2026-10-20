package com.ruoyi.iot.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PartitionInfo {
    private String tableName;
    private String partitionName;
    private String partitionExpression;
    private String partitionDescription;
    private Long tableRows;
    private Long dataLength;
    private Long indexLength;
    private LocalDateTime createTime;

    // 计算分区大小(MB)
    public Double getPartitionSizeMB() {
        if (dataLength != null && indexLength != null) {
            return Math.round((dataLength + indexLength) / 1024.0 / 1024.0 * 100.0) / 100.0;
        }
        return 0.0;
    }
}
