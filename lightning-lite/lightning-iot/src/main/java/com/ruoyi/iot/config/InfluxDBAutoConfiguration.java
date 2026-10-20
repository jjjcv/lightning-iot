package com.ruoyi.iot.config;


import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.InfluxDBClientOptions;
import lombok.extern.slf4j.Slf4j;
import okhttp3.OkHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

/**
 * InfluxDB自动配置类
 * 提供InfluxDB客户端的单例管理，供多个业务场景复用
 *
 * @author ruoyi
 */
@Slf4j
@Configuration
@ConditionalOnProperty(name = "influxdb.enabled", havingValue = "true")
public class InfluxDBAutoConfiguration {

    @Autowired
    private InfluxDBConfig influxDBConfig;

    /**
     * 创建InfluxDB客户端Bean（InfluxDB 2.x）
     */
    @Bean(destroyMethod = "close")
    public InfluxDBClient influxDBClient() {
        log.info("初始化InfluxDB客户端: url={}, org={}, bucket={}",
                influxDBConfig.getUrl(),
                influxDBConfig.getOrg(),
                influxDBConfig.getBucket());

        OkHttpClient.Builder httpBuilder = new OkHttpClient.Builder()
                .connectTimeout(influxDBConfig.getWriteTimeout(), TimeUnit.MILLISECONDS)
                .readTimeout(influxDBConfig.getQueryTimeout(), TimeUnit.MILLISECONDS)
                .writeTimeout(influxDBConfig.getWriteTimeout(), TimeUnit.MILLISECONDS);

        InfluxDBClientOptions options = InfluxDBClientOptions.builder()
                .url(influxDBConfig.getUrl())
                .authenticateToken(influxDBConfig.getToken().toCharArray())
                .org(influxDBConfig.getOrg())
                .bucket(influxDBConfig.getBucket())
                .okHttpClient(httpBuilder)
                .build();

        InfluxDBClient influxDBClient = InfluxDBClientFactory.create(options);

        log.info("InfluxDB客户端初始化成功");
        return influxDBClient;
    }

}
