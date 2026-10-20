package com.ruoyi.iot.websocket;

import cn.hutool.core.util.IdUtil;
import cn.hutool.json.JSONUtil;
import com.ruoyi.iot.cache.SubscribeCache;
import com.ruoyi.iot.domain.DeviceBinding;
import com.ruoyi.iot.domain.DeviceTelemetry;
import com.ruoyi.iot.domain.WsMessage;
import com.ruoyi.iot.scene.DeviceState;
import com.ruoyi.iot.service.DeviceWebSocketManager;
import com.ruoyi.iot.service.IDeviceBindingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class DeviceWebSocketHandler extends TextWebSocketHandler {

    @Autowired
    private DeviceWebSocketManager wsManager;

    @Autowired
    private SubscribeCache cache;

    @Autowired
    private IDeviceBindingService deviceBindingService;

    /** 1️⃣ 客户端首次连接 */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

        String ticket = IdUtil.getSnowflakeNextIdStr();
        session.getAttributes().put("ticket", ticket);

        wsManager.add(ticket, session);

        // 2️⃣ 下发 connectionId
        session.sendMessage(new TextMessage(JSONUtil.toJsonStr(
                new WsMessage<>(
                        "connected",
                        Collections.singletonMap("ticket", ticket),
                        System.currentTimeMillis()
                )
        )));

        log.info("WebSocket connected, ticket={}", ticket);
    }

    /** 3️⃣ 4️⃣ 5️⃣ 客户端注册 / 增加 / 删除设备 */
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

        WsMessage<?> msg = JSONUtil.toBean(message.getPayload(), WsMessage.class);
        String ticket = (String) session.getAttributes().get("ticket");

        switch (msg.getType()) {

            case "register":
                Set<DeviceTelemetry> registerSet =
                        JSONUtil.toList(JSONUtil.parseArray(msg.getData()), DeviceTelemetry.class)
                                .stream().collect(Collectors.toSet());

                cache.put(ticket, registerSet);
                pushInitData(ticket);
                break;

            case "add":
                DeviceTelemetry addTelemetry =
                        JSONUtil.toBean(JSONUtil.parseObj(msg.getData()), DeviceTelemetry.class);
                cache.addTelemetryTag(ticket, addTelemetry);
                pushInitData(ticket);
                break;

            case "remove":
                DeviceTelemetry removeTelemetry =
                        JSONUtil.toBean(JSONUtil.parseObj(msg.getData()), DeviceTelemetry.class);
                cache.removeTelemetryTag(ticket, removeTelemetry);
                break;

            default:
                sendError(session, "Unknown message type");
        }
    }

    /** 7️⃣ 客户端断开 */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {

        String ticket = (String) session.getAttributes().get("ticket");
        wsManager.remove(ticket);

        log.info("WebSocket closed, ticket={}", ticket);
    }

    /** ===== 全量 init 推送 ===== */
    private void pushInitData(String ticket) {

        Set<DeviceTelemetry> telemetries = cache.getTelemetryTags(ticket);
        if (telemetries == null) {
            return;
        }

        Map<String, DeviceBinding> initData = new HashMap<>();

        for (DeviceTelemetry telemetry : telemetries) {
            String tag = telemetry.getProductId() + ":" +
                    telemetry.getDeviceId() + ":" +
                    telemetry.getTelemetryKey();
            initData.put(telemetry.getComponentId(), deviceBindingService.getKeyValue(tag));
        }

        wsManager.send(ticket,
                new WsMessage<>("init", initData, System.currentTimeMillis()));
    }

    private void sendError(WebSocketSession session, String msg) throws IOException {
        session.sendMessage(new TextMessage(JSONUtil.toJsonStr(
                new WsMessage<>("error", msg, System.currentTimeMillis())
        )));
    }
}