package com.ruoyi.iot.service;

import cn.hutool.json.JSONUtil;
import com.ruoyi.iot.cache.SubscribeCache;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceTelemetry;
import com.ruoyi.iot.domain.WsMessage;
import com.ruoyi.iot.edge.DataPoint;
import com.ruoyi.iot.scene.DeviceState;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 设备WebSocket管理器
 *
 * @author fc
 */
@Component
@Slf4j
public class DeviceWebSocketManager {

    @Autowired
    private SubscribeCache cache;

    /** connectionId(ticket) -> session */
    private final Map<String, WebSocketSession> clients = new ConcurrentHashMap<>();

    public void add(String ticket, WebSocketSession session) {
        clients.put(ticket, session);
    }

    public void remove(String ticket) {
        clients.remove(ticket);
        cache.remove(ticket);
    }

    /** ===== 实时数据推送（update）===== */
    public void onPropertyChangeList(List<DeviceBinding> deviceBindings) {

        Map<String, DeviceBinding> changedData = new HashMap<>();
        Set<String> targetTickets = new HashSet<>();

        for (DeviceBinding binding : deviceBindings) {
            String key = binding.getProductId() + ":" +
                    binding.getDeviceId() + ":" +
                    binding.getTelemetryKey();

            changedData.put(key, binding);

            Set<String> tickets = cache.getTickets(key);
            if (tickets != null) {
                targetTickets.addAll(tickets);
            }
        }

        for (String ticket : targetTickets) {

            WebSocketSession session = clients.get(ticket);
            if (session == null || !session.isOpen()) {
                remove(ticket);
                continue;
            }

            Set<DeviceTelemetry> telemetries = cache.getTelemetryTags(ticket);
            if (telemetries == null) {
                continue;
            }

            Map<String, DeviceBinding> sendData = new HashMap<>();

            for (DeviceTelemetry telemetry : telemetries) {
                String tag = telemetry.getProductId() + ":" +
                        telemetry.getDeviceId() + ":" +
                        telemetry.getTelemetryKey();
                if (changedData.containsKey(tag)) {
                    sendData.put(telemetry.getComponentId(), changedData.get(tag));
                }
            }

            if (!sendData.isEmpty()) {
                send(ticket, new WsMessage<>(
                        "update",
                        sendData,
                        System.currentTimeMillis()
                ));
            }
        }
    }

    /** ===== 设备状态推送（update）===== */
    public void onDeviceState(DeviceState deviceState) {
        String productId = deviceState.getProductId();
        String deviceId = deviceState.getDeviceId();

        // 变更数据：tag -> DataPoint
        Map<String, DataPoint> changedData = new HashMap<>();
        Set<String> targetTickets = new HashSet<>();

        for (Map.Entry<String, DataPoint> entry : deviceState.getProperties().entrySet()) {
            String key = productId + ":" + deviceId + ":" + entry.getKey();
            changedData.put(key, entry.getValue());

            Set<String> tickets = cache.getTickets(key);
            if (tickets != null) {
                targetTickets.addAll(tickets);
            }
        }

        for (String ticket : targetTickets) {
            WebSocketSession session = clients.get(ticket);
            if (session == null || !session.isOpen()) {
                remove(ticket);
                continue;
            }

            Set<DeviceTelemetry> telemetries = cache.getTelemetryTags(ticket);
            if (telemetries == null) {
                continue;
            }

            Map<String, DeviceBinding> sendData = new HashMap<>();
            for (DeviceTelemetry telemetry : telemetries) {
                String tag = telemetry.getProductId() + ":" +
                        telemetry.getDeviceId() + ":" +
                        telemetry.getTelemetryKey();
                if (changedData.containsKey(tag)) {
                    sendData.put(telemetry.getComponentId(),
                            toDeviceBinding(telemetry, changedData.get(tag)));
                }
            }

            if (!sendData.isEmpty()) {
                send(ticket, new WsMessage<>(
                        "update",
                        sendData,
                        System.currentTimeMillis()
                ));
            }
        }
    }

    static DeviceBinding toDeviceBinding(DeviceTelemetry telemetry, DataPoint dataPoint) {
        DeviceBinding binding = new DeviceBinding();
        binding.setProductId(telemetry.getProductId());
        binding.setDeviceId(telemetry.getDeviceId());
        binding.setTelemetryKey(telemetry.getTelemetryKey());
        binding.setValue(dataPoint.getValue() == null ? null : String.valueOf(dataPoint.getValue()));
        binding.setDataType(dataPoint.getType() == null ? null : dataPoint.getType().getType());
        binding.setLastTime(dataPoint.getLastTime());
        return binding;
    }

    public void send(String ticket, WsMessage<?> msg) {
        try {
            WebSocketSession session = clients.get(ticket);
            if (session != null && session.isOpen()) {
                session.sendMessage(
                        new TextMessage(JSONUtil.toJsonStr(msg))
                );
            }
        } catch (Exception e) {
            remove(ticket);
        }
    }
}
