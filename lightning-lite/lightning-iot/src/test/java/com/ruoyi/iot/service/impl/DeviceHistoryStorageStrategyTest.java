package com.ruoyi.iot.service.impl;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.QueryApi;
import com.influxdb.query.FluxRecord;
import com.influxdb.query.FluxTable;
import com.github.pagehelper.Page;
import com.github.pagehelper.page.PageMethod;
import com.ruoyi.iot.config.InfluxDBConfig;
import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.mapper.DeviceHistoryMapper;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.Instant;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class DeviceHistoryStorageStrategyTest {

    @Test
    void mysqlSelectLatestReadingBeforeDelegatesToMapper() {
        DeviceHistoryMapper mapper = mock(DeviceHistoryMapper.class);
        MySqlDeviceHistoryStorageStrategy strategy = new MySqlDeviceHistoryStorageStrategy();
        ReflectionTestUtils.setField(strategy, "deviceHistoryMapper", mapper);
        DeviceHistory filter = historyFilter();
        Date beforeTime = Date.from(Instant.parse("2026-07-25T02:00:00Z"));
        DeviceHistory expected = new DeviceHistory();
        when(mapper.selectLatestReadingBefore(filter, beforeTime)).thenReturn(expected);

        DeviceHistory actual = strategy.selectLatestReadingBefore(filter, beforeTime);

        assertSame(expected, actual);
        verify(mapper).selectLatestReadingBefore(filter, beforeTime);
    }

    @Test
    void influxSelectLatestReadingBeforeUsesExclusiveStopAndReturnsReading() {
        InfluxDBClient client = mock(InfluxDBClient.class);
        QueryApi queryApi = mock(QueryApi.class);
        FluxTable table = mock(FluxTable.class);
        FluxRecord record = mock(FluxRecord.class);
        when(client.getQueryApi()).thenReturn(queryApi);
        when(queryApi.query(anyString())).thenReturn(List.of(table));
        when(table.getRecords()).thenReturn(List.of(record));
        when(record.getValueByKey("productId")).thenReturn("product-1");
        when(record.getValueByKey("deviceId")).thenReturn("device-1");
        when(record.getValueByKey("telemetryKey")).thenReturn("energy");
        when(record.getValueByKey("dataType")).thenReturn("double");
        when(record.getValue()).thenReturn(12.5D);
        when(record.getTime()).thenReturn(Instant.parse("2026-07-25T01:59:59Z"));

        InfluxDBConfig config = new InfluxDBConfig();
        config.setBucket("history-bucket");
        InfluxDBDeviceHistoryStorageStrategy strategy = new InfluxDBDeviceHistoryStorageStrategy();
        ReflectionTestUtils.setField(strategy, "influxDBClient", client);
        ReflectionTestUtils.setField(strategy, "influxDBConfig", config);
        Date beforeTime = Date.from(Instant.parse("2026-07-25T02:00:00Z"));

        DeviceHistory result = strategy.selectLatestReadingBefore(historyFilter(), beforeTime);

        assertEquals("12.5", result.getValue());
        assertEquals(Date.from(Instant.parse("2026-07-25T01:59:59Z")), result.getCreateTime());
        ArgumentCaptor<String> fluxCaptor = ArgumentCaptor.forClass(String.class);
        verify(queryApi).query(fluxCaptor.capture());
        String flux = fluxCaptor.getValue();
        assertTrue(flux.contains("stop: 2026-07-25T02:00:00Z"));
        assertTrue(flux.contains("r.productId == \"product-1\""));
        assertTrue(flux.contains("r.deviceId == \"device-1\""));
        assertTrue(flux.contains("r.telemetryKey == \"energy\""));
        assertTrue(flux.contains("r.dataType == \"double\""));
        assertTrue(flux.contains("|> last()"));
        assertTrue(flux.indexOf("|> last()") < flux.indexOf("|> group()"));
        assertTrue(flux.contains("|> sort(columns: [\"_time\"], desc: true)"));
        assertTrue(flux.contains("|> limit(n: 1)"));
    }

    @Test
    void influxSelectLatestReadingBeforeReturnsNullWhenNoReadingExists() {
        InfluxDBClient client = mock(InfluxDBClient.class);
        QueryApi queryApi = mock(QueryApi.class);
        when(client.getQueryApi()).thenReturn(queryApi);
        when(queryApi.query(anyString())).thenReturn(List.of());

        InfluxDBConfig config = new InfluxDBConfig();
        InfluxDBDeviceHistoryStorageStrategy strategy = new InfluxDBDeviceHistoryStorageStrategy();
        ReflectionTestUtils.setField(strategy, "influxDBClient", client);
        ReflectionTestUtils.setField(strategy, "influxDBConfig", config);

        DeviceHistory result = strategy.selectLatestReadingBefore(
                historyFilter(), Date.from(Instant.parse("2026-07-25T02:00:00Z")));

        assertNull(result);
    }

    @Test
    void latestReadingQueryRequiresBeforeTime() {
        MySqlDeviceHistoryStorageStrategy strategy = new MySqlDeviceHistoryStorageStrategy();

        assertThrows(IllegalArgumentException.class,
                () -> strategy.selectLatestReadingBefore(historyFilter(), null));
    }

    @Test
    void influxWindowQueryUsesServerSideAggregateWindowAndLimit() {
        InfluxDBClient client = mock(InfluxDBClient.class);
        QueryApi queryApi = mock(QueryApi.class);
        when(client.getQueryApi()).thenReturn(queryApi);
        when(queryApi.query(anyString())).thenReturn(List.of());

        InfluxDBConfig config = new InfluxDBConfig();
        config.setHistoryQueryMaxRows(250);
        InfluxDBDeviceHistoryStorageStrategy strategy = influxStrategy(client, config);
        DeviceHistory filter = historyFilter();
        filter.setIntervalSeconds(60L);

        strategy.getLastRecordsByDevice(filter);

        ArgumentCaptor<String> fluxCaptor = ArgumentCaptor.forClass(String.class);
        verify(queryApi).query(fluxCaptor.capture());
        String flux = fluxCaptor.getValue();
        assertTrue(flux.contains("|> aggregateWindow(every: 60s, fn: last, createEmpty: false, timeSrc: \"_time\")"));
        assertTrue(flux.contains("|> limit(n: 250)"));
    }

    @Test
    void influxListUsesServerSidePaginationAndReturnsTotal() {
        InfluxDBClient client = mock(InfluxDBClient.class);
        QueryApi queryApi = mock(QueryApi.class);
        FluxTable countTable = mock(FluxTable.class);
        FluxRecord countRecord = mock(FluxRecord.class);
        when(client.getQueryApi()).thenReturn(queryApi);
        when(countTable.getRecords()).thenReturn(List.of(countRecord));
        when(countRecord.getValue()).thenReturn(123L);
        when(queryApi.query(anyString())).thenReturn(List.of(countTable), List.of());

        InfluxDBConfig config = new InfluxDBConfig();
        config.setHistoryPageMaxSize(100);
        InfluxDBDeviceHistoryStorageStrategy strategy = influxStrategy(client, config);
        PageMethod.startPage(3, 50);

        List<DeviceHistory> result = strategy.selectDeviceHistoryList(historyFilter());

        Page<?> page = (Page<?>) result;
        assertEquals(3, page.getPageNum());
        assertEquals(50, page.getPageSize());
        assertEquals(123L, page.getTotal());
        ArgumentCaptor<String> fluxCaptor = ArgumentCaptor.forClass(String.class);
        verify(queryApi, times(2)).query(fluxCaptor.capture());
        List<String> queries = fluxCaptor.getAllValues();
        assertTrue(queries.get(0).contains("|> count(column: \"_value\")"));
        assertTrue(queries.get(1).contains("|> limit(n: 50, offset: 100)"));
    }

    @Test
    void influxCardinalityUsesMeasurementAndFilterPredicate() {
        InfluxDBClient client = mock(InfluxDBClient.class);
        QueryApi queryApi = mock(QueryApi.class);
        FluxTable table = mock(FluxTable.class);
        FluxRecord record = mock(FluxRecord.class);
        when(client.getQueryApi()).thenReturn(queryApi);
        when(queryApi.query(anyString())).thenReturn(List.of(table));
        when(table.getRecords()).thenReturn(List.of(record));
        when(record.getValue()).thenReturn(456L);

        InfluxDBDeviceHistoryStorageStrategy strategy = influxStrategy(client, new InfluxDBConfig());

        long cardinality = strategy.getSeriesCardinality(historyFilter());

        assertEquals(456L, cardinality);
        ArgumentCaptor<String> fluxCaptor = ArgumentCaptor.forClass(String.class);
        verify(queryApi).query(fluxCaptor.capture());
        String flux = fluxCaptor.getValue();
        assertTrue(flux.contains("import \"influxdata/influxdb\""));
        assertTrue(flux.contains("start: time(v: 1)"));
        assertTrue(flux.contains("r._measurement == \"device_history\""));
        assertTrue(flux.contains("r.telemetryKey == \"energy\""));
    }

    private InfluxDBDeviceHistoryStorageStrategy influxStrategy(InfluxDBClient client, InfluxDBConfig config) {
        InfluxDBDeviceHistoryStorageStrategy strategy = new InfluxDBDeviceHistoryStorageStrategy();
        ReflectionTestUtils.setField(strategy, "influxDBClient", client);
        ReflectionTestUtils.setField(strategy, "influxDBConfig", config);
        return strategy;
    }

    private DeviceHistory historyFilter() {
        DeviceHistory filter = new DeviceHistory();
        filter.setProductId("product-1");
        filter.setDeviceId("device-1");
        filter.setTelemetryKey("energy");
        filter.setDataType("double");
        return filter;
    }
}
