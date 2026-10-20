package com.ruoyi.iot.service.impl;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.influxdb.query.FluxRecord;
import com.influxdb.query.FluxTable;
import com.ruoyi.iot.config.InfluxDBConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 使用全局 InfluxDB 2 客户端存储设备告警数据。
 *
 * @author ruoyi
 */
@Slf4j
@Service
@ConditionalOnProperty(name = "influxdb.enabled", havingValue = "true")
public class DeviceAlarmStorageService {

    private static final String MEASUREMENT = "device_alarm";

    @Autowired
    private InfluxDBClient influxDBClient;

    @Autowired
    private InfluxDBConfig influxDBConfig;

    public void storeAlarm(String deviceId, String alarmType, String alarmLevel,
                           String message, Map<String, Object> additionalData) {
        try {
            Point point = Point.measurement(MEASUREMENT)
                    .addTag("deviceId", deviceId)
                    .addTag("alarmType", alarmType)
                    .addTag("alarmLevel", alarmLevel)
                    .addField("message", message == null ? "" : message)
                    .time(Instant.now(), WritePrecision.NS);
            if (additionalData != null) {
                additionalData.forEach((key, value) -> addField(point, key, value));
            }
            influxDBClient.getWriteApiBlocking().writePoint(point);
            log.info("设备告警数据写入成功: deviceId={}, alarmType={}", deviceId, alarmType);
        } catch (Exception e) {
            log.error("设备告警数据写入失败", e);
            throw new RuntimeException("设备告警数据写入失败", e);
        }
    }

    public void storeAlarmsBatch(List<Map<String, Object>> alarms) {
        if (alarms == null || alarms.isEmpty()) {
            return;
        }
        for (Map<String, Object> alarm : alarms) {
            @SuppressWarnings("unchecked")
            Map<String, Object> additionalData = (Map<String, Object>) alarm.get("additionalData");
            storeAlarm((String) alarm.get("deviceId"), (String) alarm.get("alarmType"),
                    (String) alarm.get("alarmLevel"), (String) alarm.get("message"), additionalData);
        }
    }

    public List<Map<String, Object>> queryAlarms(String deviceId, Date startTime, Date endTime) {
        try {
            StringBuilder flux = new StringBuilder();
            flux.append("from(bucket: ").append(fluxQuoted(influxDBConfig.getBucket())).append(")\n");
            flux.append("  |> range(start: ").append(startTime.toInstant())
                    .append(", stop: ").append(endTime.toInstant()).append(")\n");
            flux.append("  |> filter(fn: (r) => r._measurement == ").append(fluxQuoted(MEASUREMENT)).append("\n");
            if (deviceId != null && !deviceId.isEmpty()) {
                flux.append("  |> filter(fn: (r) => r.deviceId == ").append(fluxQuoted(deviceId)).append("\n");
            }
            // pivot 把各 field 列展开为列，等价于 SQL 选取字段列
            flux.append("  |> pivot(rowKey: [\"_time\"], columnKey: [\"_field\"], valueColumn: \"_value\")\n");
            flux.append("  |> sort(columns: [\"_time\"], desc: true)");

            List<Map<String, Object>> results = new ArrayList<>();
            List<FluxTable> tables = influxDBClient.getQueryApi().query(flux.toString());
            for (FluxTable table : tables) {
                for (FluxRecord record : table.getRecords()) {
                    Map<String, Object> alarm = new HashMap<>();
                    alarm.put("deviceId", record.getValueByKey("deviceId"));
                    alarm.put("alarmType", record.getValueByKey("alarmType"));
                    alarm.put("alarmLevel", record.getValueByKey("alarmLevel"));
                    alarm.put("message", record.getValueByKey("message"));
                    Instant time = record.getTime();
                    alarm.put("timestamp", time == null ? null : Date.from(time));
                    results.add(alarm);
                }
            }
            return results;
        } catch (Exception e) {
            log.error("查询设备告警数据失败", e);
            throw new RuntimeException("查询设备告警数据失败", e);
        }
    }

    private void addField(Point point, String key, Object value) {
        if (value == null) {
            return;
        }
        if (value instanceof Boolean b) {
            point.addField(key, b);
        } else if (value instanceof Number n) {
            point.addField(key, n);
        } else if (value instanceof String s) {
            point.addField(key, s);
        } else {
            point.addField(key, value.toString());
        }
    }

    private String fluxQuoted(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }
}
