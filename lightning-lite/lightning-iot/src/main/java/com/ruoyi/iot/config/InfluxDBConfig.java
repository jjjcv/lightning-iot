package com.ruoyi.iot.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * InfluxDB配置类
 * 
 * @author ruoyi
 */
@Data
@Component
@ConfigurationProperties(prefix = "influxdb")
public class InfluxDBConfig {
    
    /**
     * 是否启用InfluxDB
     */
    private boolean enabled = false;
    
    /**
     * InfluxDB服务器URL
     */
    private String url = "http://localhost:8181";
    
    /**
     * InfluxDB认证令牌
     */
    private String token = "";
    
    /**
     * InfluxDB组织名称
     */
    private String org = "";
    
    /**
     * InfluxDB 2 bucket 名称（对应 v3 的 database）
     */
    private String bucket = "device_history";

    /**
     * 写入超时时间（毫秒）
     */
    private int writeTimeout = 10000;

    /**
     * 查询超时时间（毫秒）
     */
    private int queryTimeout = 10000;

    /**
     * 非分页历史查询最大返回行数。
     */
    private int historyQueryMaxRows = 10000;

    /**
     * 历史分页查询允许的最大页大小。
     */
    private int historyPageMaxSize = 1000;
}
