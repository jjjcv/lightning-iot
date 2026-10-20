package com.ruoyi.iot.service.impl;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.influxdb.query.FluxRecord;
import com.influxdb.query.FluxTable;
import com.github.pagehelper.Page;
import com.github.pagehelper.page.PageMethod;
import com.ruoyi.iot.config.InfluxDBConfig;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.enums.StorageStrategyEnum;
import com.ruoyi.iot.metadata.DataType;
import com.ruoyi.iot.metadata.ValueTypeTranslator;
import com.ruoyi.iot.metadata.types.DataTypes;
import com.ruoyi.iot.service.IDeviceHistoryStorageStrategy;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicLong;
import java.util.function.Supplier;

/**
 * 基于 InfluxDB 2 Java Client 的设备历史数据存储策略。
 *
 * @author ruoyi
 */
@Slf4j
@Service
@ConditionalOnProperty(name = "device.history.storage.strategy", havingValue = "influxdb")
public class InfluxDBDeviceHistoryStorageStrategy implements IDeviceHistoryStorageStrategy {

    private static final String MEASUREMENT = "device_history";
    private static final String VALUE_FIELD = "value";
    /** 无起始时间时默认回溯 30 天 */
    private static final String DEFAULT_START = "-30d";

    @Autowired
    private InfluxDBClient influxDBClient;

    @Autowired
    private InfluxDBConfig influxDBConfig;

    @Override
    public String getStrategyName() {
        return StorageStrategyEnum.INFLUXDB.getCode();
    }

    @Override
    public List<DeviceHistory> selectDeviceHistoryList(DeviceHistory deviceHistory) {
        Page<DeviceHistory> requestedPage = PageMethod.getLocalPage();
        try {
            if (requestedPage == null) {
                return queryHistory(deviceHistory, false, queryMaxRows(), 0L);
            }

            int pageNum = Math.max(1, requestedPage.getPageNum());
            int pageSize = Math.max(1, Math.min(requestedPage.getPageSize(), pageMaxSize()));
            long offset = (long) (pageNum - 1) * pageSize;
            long total = countHistory(deviceHistory);
            List<DeviceHistory> rows = queryHistory(deviceHistory, false, pageSize, offset);

            Page<DeviceHistory> result = new Page<>(pageNum, pageSize);
            result.setTotal(total);
            result.addAll(rows);
            return result;
        } catch (Exception e) {
            throw new RuntimeException("查询InfluxDB数据失败", e);
        } finally {
            if (requestedPage != null) {
                PageMethod.clearPage();
            }
        }
    }

    @Override
    public DeviceHistory selectDeviceHistoryById(Long id) {
        throw new UnsupportedOperationException("InfluxDB不支持通过ID查询单条记录");
    }

    @Override
    public DeviceHistory selectLatestReadingBefore(DeviceHistory deviceHistory, Date beforeTime) {
        validateLatestReadingQuery(deviceHistory, beforeTime);
        try {
            StringBuilder flux = new StringBuilder();
            flux.append("from(bucket: ").append(fluxQuoted(influxDBConfig.getBucket())).append(")\n");
            flux.append("  |> range(start: 1970-01-01T00:00:00Z, stop: ")
                    .append(rangeBound(beforeTime, null)).append(")\n");
            flux.append("  |> filter(fn: (r) => r._measurement == ").append(fluxQuoted(MEASUREMENT)).append(")\n");
            flux.append("  |> filter(fn: (r) => r._field == ").append(fluxQuoted(VALUE_FIELD)).append(")\n");
            appendFluxFilter(flux, "productId", deviceHistory.getProductId());
            appendFluxFilter(flux, "deviceId", deviceHistory.getDeviceId());
            appendFluxFilter(flux, "telemetryKey", deviceHistory.getTelemetryKey());
            appendFluxFilter(flux, "dataType", deviceHistory.getDataType());
            // last() 先将每个 series 缩减为一个候选点，再做全局最新值选择。
            flux.append("  |> last()\n");
            flux.append("  |> group()\n");
            flux.append("  |> sort(columns: [\"_time\"], desc: true)\n");
            flux.append("  |> limit(n: 1)");

            List<FluxTable> tables = influxDBClient.getQueryApi().query(flux.toString());
            for (FluxTable table : tables) {
                if (!table.getRecords().isEmpty()) {
                    DeviceHistory result = toDeviceHistory(table.getRecords().get(0));
                    result.setId(0L);
                    return result;
                }
            }
            return null;
        } catch (Exception e) {
            throw new RuntimeException("查询InfluxDB指定时间前最新读数失败", e);
        }
    }

    @Override
    public List<DeviceHistory> getLastRecordsByDevice(DeviceHistory deviceHistory) {
        try {
            Long intervalSeconds = deviceHistory.getIntervalSeconds();
            if (intervalSeconds == null || intervalSeconds <= 0) {
                return queryHistory(deviceHistory, true, queryMaxRows(), 0L);
            }

            StringBuilder flux = historySource(deviceHistory);
            flux.append("  |> aggregateWindow(every: ").append(intervalSeconds)
                    .append("s, fn: last, createEmpty: false, timeSrc: \"_time\")\n");
            flux.append("  |> group()\n");
            flux.append("  |> sort(columns: [\"_time\"], desc: false)\n");
            flux.append("  |> limit(n: ").append(queryMaxRows()).append(")");
            return executeHistoryQuery(flux);
        } catch (Exception e) {
            throw new RuntimeException("查询InfluxDB时间窗口数据失败", e);
        }
    }

    @Override
    public long getSeriesCardinality(DeviceHistory deviceHistory) {
        DeviceHistory filter = deviceHistory == null ? new DeviceHistory() : deviceHistory;
        try {
            StringBuilder flux = new StringBuilder();
            flux.append("import \"influxdata/influxdb\"\n\n");
            flux.append("influxdb.cardinality(\n");
            flux.append("  bucket: ").append(fluxQuoted(influxDBConfig.getBucket())).append(",\n");
            flux.append("  start: ").append(rangeBound(filter.getStartTime(), "time(v: 1)")).append(",\n");
            flux.append("  stop: ").append(rangeBound(filter.getEndTime(), "now()")).append(",\n");
            flux.append("  predicate: (r) => r._measurement == ").append(fluxQuoted(MEASUREMENT));
            flux.append(" and r._field == ").append(fluxQuoted(VALUE_FIELD));
            appendFluxPredicate(flux, "productId", filter.getProductId());
            appendFluxPredicate(flux, "deviceId", filter.getDeviceId());
            appendFluxPredicate(flux, "telemetryKey", filter.getTelemetryKey());
            appendFluxPredicate(flux, "dataType", filter.getDataType());
            flux.append("\n)");
            return sumValues(influxDBClient.getQueryApi().query(flux.toString()));
        } catch (Exception e) {
            throw new RuntimeException("统计InfluxDB series cardinality失败", e);
        }
    }

    @Override
    public int insertBatch(List<DeviceHistory> deviceHistoryList) {
        if (deviceHistoryList == null || deviceHistoryList.isEmpty()) {
            return 0;
        }

        try {
            List<Point> points = deviceHistoryList.stream()
                    .map(this::toPoint)
                    .filter(Objects::nonNull)
                    .toList();
            if (points.isEmpty()) {
                log.warn("批量写入InfluxDB跳过：{} 条历史值均无法转换为Double", deviceHistoryList.size());
                return 0;
            }
            influxDBClient.getWriteApiBlocking().writePoints(points);
            int skipped = deviceHistoryList.size() - points.size();
            if (skipped > 0) {
                log.warn("批量写入InfluxDB：成功 {} 条，跳过 {} 条无法转换为Double的记录", points.size(), skipped);
            } else {
                log.debug("批量写入InfluxDB成功，数量: {}", points.size());
            }
            return points.size();
        } catch (Exception e) {
            log.error("批量写入InfluxDB失败", e);
            throw new RuntimeException("批量写入InfluxDB失败", e);
        }
    }

    @Override
    public int insertDeviceHistory(DeviceHistory deviceHistory) {
        Point point = toPoint(deviceHistory);
        if (point == null) {
            log.warn("写入InfluxDB跳过：历史值无法转换为Double，dataType={}, value={}",
                    deviceHistory.getDataType(), deviceHistory.getValue());
            return 0;
        }
        try {
            influxDBClient.getWriteApiBlocking().writePoint(point);
            return 1;
        } catch (Exception e) {
            log.error("写入InfluxDB失败", e);
            throw new RuntimeException("写入InfluxDB失败", e);
        }
    }

    @Override
    public int deleteDeviceHistoryByIds(Long[] ids) {
        throw new UnsupportedOperationException("InfluxDB不支持通过ID批量删除记录");
    }

    @Override
    public int deleteDeviceHistoryById(Long id) {
        throw new UnsupportedOperationException("InfluxDB不支持通过ID删除单条记录");
    }

    @Override
    public int deleteExpiredByProduct(String productId, Date beforeTime) {
        if (productId == null || productId.isEmpty() || beforeTime == null) {
            return 0;
        }
        try {
            // 删除区间：[epoch, beforeTime)，限定 measurement 和 productId，避免影响同 bucket 其他业务。
            OffsetDateTime start = OffsetDateTime.ofInstant(Instant.EPOCH, ZoneOffset.UTC);
            OffsetDateTime stop = OffsetDateTime.ofInstant(beforeTime.toInstant(), ZoneOffset.UTC);
            String predicate = "_measurement=" + fluxQuoted(MEASUREMENT)
                    + " AND productId=" + fluxQuoted(productId);
            influxDBClient.getDeleteApi().delete(start, stop, predicate,
                    influxDBConfig.getBucket(), influxDBConfig.getOrg());
            log.info("InfluxDB 按产品删除过期历史成功: productId={}, beforeTime={}", productId, beforeTime);
            // InfluxDB 删除不返回行数，按接口约定返回 0
            return 0;
        } catch (Exception e) {
            log.error("InfluxDB 按产品删除过期历史失败: productId={}", productId, e);
            throw new RuntimeException("InfluxDB 按产品删除过期历史失败", e);
        }
    }

    /**
     * 查询历史数据。
     *
     * @param filter    过滤条件
     * @param ascending true=按时间升序（用于时间窗口取最后值），false=降序
     */
    private List<DeviceHistory> queryHistory(DeviceHistory filter, boolean ascending, int limit, long offset) {
        StringBuilder flux = historySource(filter);
        // group() 合并所有 series 后排序，等价于 SQL 的全局 ORDER BY time
        flux.append("  |> group()\n");
        flux.append("  |> sort(columns: [\"_time\"], desc: ").append(ascending ? "false" : "true").append(")\n");
        flux.append("  |> limit(n: ").append(limit).append(", offset: ").append(offset).append(")");
        return executeHistoryQuery(flux);
    }

    private StringBuilder historySource(DeviceHistory filter) {
        DeviceHistory actualFilter = filter == null ? new DeviceHistory() : filter;
        StringBuilder flux = new StringBuilder();
        flux.append("from(bucket: ").append(fluxQuoted(influxDBConfig.getBucket())).append(")\n");
        flux.append("  |> range(start: ").append(rangeBound(actualFilter.getStartTime(), DEFAULT_START))
                .append(", stop: ").append(rangeBound(actualFilter.getEndTime(), "now()")).append(")\n");
        flux.append("  |> filter(fn: (r) => r._measurement == ").append(fluxQuoted(MEASUREMENT)).append(")\n");
        flux.append("  |> filter(fn: (r) => r._field == ").append(fluxQuoted(VALUE_FIELD)).append(")\n");
        appendFluxFilter(flux, "productId", actualFilter.getProductId());
        appendFluxFilter(flux, "deviceId", actualFilter.getDeviceId());
        appendFluxFilter(flux, "telemetryKey", actualFilter.getTelemetryKey());
        appendFluxFilter(flux, "dataType", actualFilter.getDataType());
        return flux;
    }

    private List<DeviceHistory> executeHistoryQuery(StringBuilder flux) {
        List<DeviceHistory> result = new ArrayList<>();
        List<FluxTable> tables = influxDBClient.getQueryApi().query(flux.toString());
        for (FluxTable table : tables) {
            for (FluxRecord record : table.getRecords()) {
                result.add(toDeviceHistory(record));
            }
        }
        assignIds(result);
        return result;
    }

    private long countHistory(DeviceHistory filter) {
        StringBuilder flux = historySource(filter);
        flux.append("  |> group()\n");
        flux.append("  |> count(column: \"_value\")");
        return sumValues(influxDBClient.getQueryApi().query(flux.toString()));
    }

    private long sumValues(List<FluxTable> tables) {
        long total = 0L;
        for (FluxTable table : tables) {
            for (FluxRecord record : table.getRecords()) {
                Object value = record.getValue();
                if (value instanceof Number number) {
                    total = Math.addExact(total, number.longValue());
                }
            }
        }
        return total;
    }

    private void appendFluxFilter(StringBuilder flux, String column, String value) {
        if (value != null && !value.isEmpty()) {
            flux.append("  |> filter(fn: (r) => r.").append(column)
                    .append(" == ").append(fluxQuoted(value)).append(")\n");
        }
    }

    private void appendFluxPredicate(StringBuilder flux, String column, String value) {
        if (value != null && !value.isEmpty()) {
            flux.append(" and r.").append(column).append(" == ").append(fluxQuoted(value));
        }
    }

    private int queryMaxRows() {
        return Math.max(1, influxDBConfig.getHistoryQueryMaxRows());
    }

    private int pageMaxSize() {
        return Math.max(1, influxDBConfig.getHistoryPageMaxSize());
    }

    /**
     * 时间区间边界：value 非空时用 RFC3339 时间字面量，否则用默认表达式（如 -30d / now()）。
     */
    private String rangeBound(Date value, String defaultExpression) {
        return value == null ? defaultExpression : value.toInstant().toString();
    }

    /**
     * 构造 Flux 双引号字符串字面量，转义反斜杠与双引号。
     */
    private String fluxQuoted(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }

    private Point toPoint(DeviceHistory history) {
        Double value = toDoubleValue(history);
        if (value == null) {
            return null;
        }
        Point point = Point.measurement(MEASUREMENT)
                .addField(VALUE_FIELD, value)
                .time(history.getCreateTime() == null ? Instant.now() : history.getCreateTime().toInstant(),
                        WritePrecision.NS);
        addTagIfPresent(point, "productId", history.getProductId());
        addTagIfPresent(point, "deviceId", history.getDeviceId());
        addTagIfPresent(point, "telemetryKey", history.getTelemetryKey());
        addTagIfPresent(point, "dataType", history.getDataType());
        return point;
    }

    /**
     * 将上报值统一转换为 Double。
     * 仅当物模型数据类型为数值型（含数值型枚举）且转换成功时返回非 null；
     * 布尔/日期/字符串/JSON 等非数值类型、类型未知或转换失败时返回 null，
     * 由调用方据此跳过不存储（无法转换的就不存储）。
     */
    private Double toDoubleValue(DeviceHistory history) {
        DataType dataType = lookupDataType(history.getDataType());
        if (dataType == null) {
            return null;
        }
        Object translated;
        try {
            translated = ValueTypeTranslator.translator(history.getValue(), dataType);
        } catch (Exception e) {
            log.warn("历史值类型转换失败: dataType={}, value={}", history.getDataType(), history.getValue(), e);
            return null;
        }
        if (translated instanceof Number num) {
            return num.doubleValue();
        }

        if (translated instanceof String str) {
            return Double.valueOf(str);
        }

        if (translated instanceof Boolean) {
            return (double) ((Boolean) translated ? 1 : 0);
        }

        return null;
    }

    private DataType lookupDataType(String id) {
        Supplier<DataType> supplier = DataTypes.lookup(id);
        return supplier == null ? null : supplier.get();
    }

    private void addTagIfPresent(Point point, String key, String value) {
        if (value != null && !value.isEmpty()) {
            point.addTag(key, value);
        }
    }

    private DeviceHistory toDeviceHistory(FluxRecord record) {
        DeviceHistory history = new DeviceHistory();
        history.setProductId(asString(record.getValueByKey("productId")));
        history.setDeviceId(asString(record.getValueByKey("deviceId")));
        history.setTelemetryKey(asString(record.getValueByKey("telemetryKey")));
        history.setDataType(asString(record.getValueByKey("dataType")));
        history.setValue(asString(record.getValue()));
        Instant time = record.getTime();
        history.setCreateTime(time == null ? null : Date.from(time));
        return history;
    }

    private String asString(Object value) {
        return value == null ? "" : value.toString();
    }

    private void assignIds(List<DeviceHistory> histories) {
        AtomicLong id = new AtomicLong();
        histories.forEach(history -> history.setId(id.getAndIncrement()));
    }

    private void validateLatestReadingQuery(DeviceHistory deviceHistory, Date beforeTime) {
        if (deviceHistory == null) {
            throw new IllegalArgumentException("查询条件不能为空");
        }
        if (beforeTime == null) {
            throw new IllegalArgumentException("时间上限不能为空");
        }
    }
}
