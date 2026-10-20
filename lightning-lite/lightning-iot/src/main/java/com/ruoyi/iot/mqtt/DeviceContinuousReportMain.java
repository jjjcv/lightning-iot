package com.ruoyi.iot.mqtt;

import com.alibaba.fastjson2.JSON;
import com.hivemq.client.mqtt.MqttClient;
import com.hivemq.client.mqtt.datatypes.MqttQos;
import com.hivemq.client.mqtt.mqtt5.Mqtt5AsyncClient;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.metadata.types.DataTypes;
import com.ruoyi.iot.scene.DeviceState;

import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

public class DeviceContinuousReportMain {

    // ======== 核心参数 ========
    private static final int DEVICE_COUNT = 266;     // 10w 设备
    private static final int REPORT_INTERVAL_SEC = 10;    // 每 5 秒上报一次
    private static final int MAX_INFLIGHT = 2000;        // QoS1 在飞
    // ========================

    private static final Random random = new Random();
    private static final AtomicLong totalSent = new AtomicLong();

    public static void main(String[] args) throws Exception {

        // 1️⃣ MQTT Client
        Mqtt5AsyncClient mqttClient = MqttClient.builder()
                .useMqttVersion5()
                .identifier("iot-gateway-" + UUID.randomUUID())
                .serverHost("127.0.0.1")
                .serverPort(1883)
                .automaticReconnectWithDefaultConfig()
                .simpleAuth()
                .username("admin")
                .password("public".getBytes())
                .applySimpleAuth()
                .buildAsync();

        mqttClient.connect().join();
        System.out.println("MQTT connected");

        // 2️⃣ inflight 控制
        Semaphore inflight = new Semaphore(MAX_INFLIGHT);

        // 3️⃣ 周期调度器（真实设备行为）
        ScheduledExecutorService scheduler =
                Executors.newSingleThreadScheduledExecutor();

        scheduler.scheduleAtFixedRate(() -> {

            long cycleStart = System.currentTimeMillis();
            System.out.println("=== report cycle start ===");

            for (int deviceId = 1; deviceId <= DEVICE_COUNT; deviceId++) {

                try {
                    inflight.acquire();
                } catch (InterruptedException e) {
                    return;
                }

                DeviceState state =
                        new DeviceState("product-teslJA1231234", "device-" + deviceId);

                state.getProperties().put("temperature", point("temperature"));
                state.getProperties().put("humidity", point("humidity"));
                state.getProperties().put("pressure", point("pressure"));
                state.getProperties().put("co2", point("co2"));
                state.getProperties().put("pm25", point("pm25"));
                state.getProperties().put("pm10", point("pm10"));
                state.setLastUpdateTime(java.time.LocalDateTime.now());

                String topic = "/product-teslJA1231234/device-" + deviceId + "/properties/report";
                byte[] payload = JSON.toJSONString(state)
                        .getBytes(StandardCharsets.UTF_8);

                mqttClient.publishWith()
                        .topic(topic)
                        .qos(MqttQos.AT_LEAST_ONCE)
                        .payload(payload)
                        .send()
                        .whenComplete((ack, ex) -> {
                            inflight.release();
                            totalSent.incrementAndGet();

                            if (ex != null) {
                                System.err.println("publish failed: " + ex.getMessage());
                            }
                        });
            }

            long cost = System.currentTimeMillis() - cycleStart;
            System.out.println("cycle dispatched, cost=" + cost + "ms");

        }, 0, REPORT_INTERVAL_SEC, TimeUnit.SECONDS);

        // 4️⃣ TPS 监控（可选，但强烈推荐）
        Executors.newSingleThreadScheduledExecutor()
                .scheduleAtFixedRate(() -> {
                    System.out.println(
                            "TOTAL SENT = " + totalSent.get() +
                                    ", inflight = " + (MAX_INFLIGHT - inflight.availablePermits())
                    );
                }, 5, 5, TimeUnit.SECONDS);
    }

    private static DataPoint point(String id) {
        return DataPoint.builder()
                .id(id)
                .name(id)
                .type(DataTypes.lookup("double").get())
                .value(random.nextInt(100))
                .build();
    }
}
