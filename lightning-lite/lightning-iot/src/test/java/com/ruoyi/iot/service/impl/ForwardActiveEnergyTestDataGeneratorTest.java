package com.ruoyi.iot.service.impl;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.WriteApiBlocking;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.influxdb.query.FluxRecord;
import com.influxdb.query.FluxTable;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.Year;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Generates deterministic cumulative energy readings for local InfluxDB testing.
 *
 * <p>The write test is disabled during normal builds. Enable it explicitly with
 * {@code -Dgenerate.forward-active-energy=true}. Connection settings are read from
 * {@code influx.url}, {@code influx.org}, {@code influx.bucket} and {@code INFLUX_TOKEN}.
 */
class ForwardActiveEnergyTestDataGeneratorTest {

    private static final String MEASUREMENT = "device_history";
    private static final String VALUE_FIELD = "value";
    private static final String PRODUCT_ID = "electrical";
    private static final String TELEMETRY_KEY = "ForwardActiveEnergy";
    private static final String DATA_TYPE = "double";
    private static final ZoneId DATA_ZONE = ZoneId.of("Asia/Shanghai");
    private static final int FIRST_DEVICE = 1;
    private static final int LAST_DEVICE = 30;
    private static final int WRITE_BATCH_SIZE = 5_000;

    @Test
    void generatedReadingsCoverTheWholeYearAndRemainCumulative() {
        List<Reading> readings = generateReadings(1, 2025);

        assertEquals(8_761, readings.size());
        assertEquals(Instant.parse("2024-12-31T15:59:59Z"), readings.getFirst().time());
        assertEquals(Instant.parse("2025-12-31T15:59:59Z"), readings.getLast().time());
        for (int i = 1; i < readings.size(); i++) {
            assertTrue(readings.get(i).value() > readings.get(i - 1).value(),
                    "Cumulative reading must increase at index " + i);
        }
    }

    @Test
    @EnabledIfSystemProperty(named = "generate.forward-active-energy", matches = "true")
    void generateLastYearsReadingsInInfluxDB() {
        int year = Integer.getInteger("test.data.year", Year.now(DATA_ZONE).minusYears(1).getValue());
        String url = System.getProperty("influx.url", "http://localhost:8086");
        String org = System.getProperty("influx.org", "lightning");
        String bucket = System.getProperty("influx.bucket", "device_history");
        String token = "oNuGaPRAlU70g9YuBOhS5ZqQopD-j12j_WkM5QTGFZWi0cBAaUGsnYInNClkTCzoroFtGwd4oeYi5SPAxmD9Jw==";
        int readingsPerDevice = generateReadings(FIRST_DEVICE, year).size();

        long total = 0L;
        try (InfluxDBClient client = InfluxDBClientFactory.create(url, token.toCharArray(), org, bucket)) {
            WriteApiBlocking writeApi = client.getWriteApiBlocking();
            List<Point> batch = new ArrayList<>(WRITE_BATCH_SIZE);

            for (int deviceNumber = FIRST_DEVICE; deviceNumber <= LAST_DEVICE; deviceNumber++) {
                String deviceId = "el" + deviceNumber;
                for (Reading reading : generateReadings(deviceNumber, year)) {
                    batch.add(toPoint(deviceId, reading));
                    if (batch.size() == WRITE_BATCH_SIZE) {
                        writeApi.writePoints(batch);
                        total += batch.size();
                        batch.clear();
                    }
                }
            }

            if (!batch.isEmpty()) {
                writeApi.writePoints(batch);
                total += batch.size();
            }

            verifyPersistedReadings(client, bucket, year, readingsPerDevice);
        }

        long expected = (long) (LAST_DEVICE - FIRST_DEVICE + 1)
                * readingsPerDevice;
        assertEquals(expected, total);
        System.out.printf(
                "Generated %,d %s readings for el%d-el%d, year=%d, productId=%s%n",
                total, TELEMETRY_KEY, FIRST_DEVICE, LAST_DEVICE, year, PRODUCT_ID);
    }

    private static void verifyPersistedReadings(InfluxDBClient client, String bucket, int year,
            int expectedPerDevice) {
        Instant start = ZonedDateTime.of(year - 1, 12, 31, 23, 59, 59, 0, DATA_ZONE).toInstant();
        Instant stop = ZonedDateTime.of(year + 1, 1, 1, 0, 0, 0, 0, DATA_ZONE).toInstant();
        String flux = "from(bucket: " + fluxQuoted(bucket) + ")\n"
                + "  |> range(start: " + start + ", stop: " + stop + ")\n"
                + "  |> filter(fn: (r) => r._measurement == " + fluxQuoted(MEASUREMENT) + ")\n"
                + "  |> filter(fn: (r) => r._field == " + fluxQuoted(VALUE_FIELD) + ")\n"
                + "  |> filter(fn: (r) => r.productId == " + fluxQuoted(PRODUCT_ID) + ")\n"
                + "  |> filter(fn: (r) => r.telemetryKey == " + fluxQuoted(TELEMETRY_KEY) + ")\n"
                + "  |> filter(fn: (r) => r.dataType == " + fluxQuoted(DATA_TYPE) + ")\n"
                + "  |> filter(fn: (r) => r.deviceId =~ /^el([1-9]|[12][0-9]|30)$/)\n"
                + "  |> group(columns: [\"deviceId\"])\n"
                + "  |> count(column: \"_value\")";

        Map<String, Long> persistedCounts = new HashMap<>();
        for (FluxTable table : client.getQueryApi().query(flux)) {
            for (FluxRecord record : table.getRecords()) {
                Object deviceId = record.getValueByKey("deviceId");
                Object count = record.getValue();
                if (deviceId != null && count instanceof Number number) {
                    persistedCounts.put(deviceId.toString(), number.longValue());
                }
            }
        }

        for (int deviceNumber = FIRST_DEVICE; deviceNumber <= LAST_DEVICE; deviceNumber++) {
            String deviceId = "el" + deviceNumber;
            assertTrue(persistedCounts.getOrDefault(deviceId, 0L) >= expectedPerDevice,
                    () -> deviceId + " has fewer persisted readings than expected: "
                            + persistedCounts.getOrDefault(deviceId, 0L));
        }
    }

    private static List<Reading> generateReadings(int deviceNumber, int year) {
        ZonedDateTime baseline = ZonedDateTime.of(year - 1, 12, 31, 23, 59, 59, 0, DATA_ZONE);
        ZonedDateTime lastReading = ZonedDateTime.of(year, 12, 31, 23, 59, 59, 0, DATA_ZONE);
        int pointCount = Math.toIntExact(ChronoUnit.HOURS.between(baseline, lastReading) + 1);
        List<Reading> readings = new ArrayList<>(pointCount);
        double cumulativeEnergy = 10_000.0 + deviceNumber * 1_000.0;

        for (int index = 0; index < pointCount; index++) {
            ZonedDateTime readingTime = baseline.plusHours(index);
            if (index > 0) {
                cumulativeEnergy += hourlyConsumption(deviceNumber, readingTime.minusHours(1));
            }
            cumulativeEnergy = round(cumulativeEnergy, 6);
            readings.add(new Reading(readingTime.toInstant(), cumulativeEnergy));
        }
        return readings;
    }

    private static double hourlyConsumption(int deviceNumber, ZonedDateTime hour) {
        double deviceBaseLoad = 8.0 + deviceNumber * 0.35;
        int localHour = hour.getHour();
        double timeOfDayFactor = localHour >= 8 && localHour < 19 ? 1.35 : 0.65;
        DayOfWeek dayOfWeek = hour.getDayOfWeek();
        double weekdayFactor = dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY
                ? 0.72 : 1.0;
        double seasonalFactor = 1.0 + 0.18 * Math.sin(
                2.0 * Math.PI * (hour.getDayOfYear() - 30) / hour.toLocalDate().lengthOfYear());
        long noiseSeed = deviceNumber * 1_000_003L + hour.toEpochSecond() / 3_600L;
        double deterministicNoise = 0.92 + Math.floorMod(noiseSeed * 48_271L, 10_000L) / 62_500.0;
        return deviceBaseLoad * timeOfDayFactor * weekdayFactor * seasonalFactor * deterministicNoise;
    }

    private static Point toPoint(String deviceId, Reading reading) {
        return Point.measurement(MEASUREMENT)
                .addTag("dataType", DATA_TYPE)
                .addTag("deviceId", deviceId)
                .addTag("productId", PRODUCT_ID)
                .addTag("telemetryKey", TELEMETRY_KEY)
                .addField(VALUE_FIELD, reading.value())
                .time(reading.time(), WritePrecision.NS);
    }

    private static double round(double value, int scale) {
        return BigDecimal.valueOf(value).setScale(scale, RoundingMode.HALF_UP).doubleValue();
    }

    private static String requiredEnvironmentVariable(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException(name + " must be set before generating InfluxDB test data");
        }
        return value;
    }

    private static String fluxQuoted(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }

    private record Reading(Instant time, double value) {
    }
}
