package com.ruoyi.iot.listener;

import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.event.DeviceHistoryEvent;
import com.ruoyi.iot.service.IDeviceHistoryService;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 设备历史数据落库监听器。
 *
 * <p>消费 {@link DeviceHistoryEvent}（由 DeviceStateListener / DeviceBindingListener 在设备上报时组装），
 * 按 {@code Product.storageInterval} 节流后批量落库：
 * <ul>
 *   <li>{@code storageInterval <= 0}：上报即落库，每条都存；</li>
 *   <li>{@code storageInterval > 0}：仅当 {@code value} 与上次入库值（{@code historyValue}）不同、
 *       且距上次入库已达间隔才存（变化且间隔达标）。</li>
 * </ul>
 *
 * <p>节流时钟用墙钟时间（上次“入库”时刻），{@code createTime} 仍用上报的 lastTime。
 */
@Slf4j
@Component
public class DeviceHistoryListener implements ApplicationListener<DeviceHistoryEvent> {

    private final IDeviceHistoryService deviceHistoryService;
    private final DeviceHistoryThrottle throttle;

    public DeviceHistoryListener(IDeviceHistoryService deviceHistoryService, DeviceHistoryThrottle throttle) {
        this.deviceHistoryService = deviceHistoryService;
        this.throttle = throttle;
    }

    @Async("virtualThreadExecutor")
    @Override
    public void onApplicationEvent(DeviceHistoryEvent event) {
        @SuppressWarnings("unchecked")
        List<DeviceHistory> deviceHistoryList = (List<DeviceHistory>) event.getSource();
        if (deviceHistoryList == null || deviceHistoryList.isEmpty()) {
            return;
        }

        long now = System.currentTimeMillis();
        List<DeviceHistory> toStore = new ArrayList<>(deviceHistoryList.size());

        for (DeviceHistory history : deviceHistoryList) {
            if (history == null || history.getDeviceId() == null || history.getTelemetryKey() == null) {
                continue;
            }

            // 停用产品不写入历史；节流器会同时清理该产品既有采样状态。
            if (!throttle.isProductEnabled(history.getProductId())) {
                continue;
            }

            String key = samplingKey(history);
            DeviceHistoryThrottle.Sample sample = throttle.get(key);

            long interval = throttle.getStorageInterval(history.getProductId());
            boolean store;
            if (interval <= 0L) {
                // 上报即落库
                store = true;
            } else {
                boolean changed = sample == null || !Objects.equals(history.getValue(), sample.getLastValue());
                boolean intervalMet = sample == null || (now - sample.getLastStoreTime() >= interval);
                store = changed && intervalMet;
            }

            if (store) {
                toStore.add(history);
            }
        }

        if (toStore.isEmpty()) {
            return;
        }

        // 异步处理期间产品可能被停用；写入前再次确认，避免已筛选的数据继续落库。
        toStore.removeIf(history -> !throttle.isProductEnabled(history.getProductId()));
        if (toStore.isEmpty()) {
            return;
        }

        try {
            deviceHistoryService.insertBatch(toStore);
            // 入库成功后更新采样状态
            for (DeviceHistory history : toStore) {
                // 若写入期间产品被停用，不得重新建立已被清理的采样状态。
                if (throttle.isProductEnabled(history.getProductId())) {
                    throttle.update(history.getProductId(), samplingKey(history), now, history.getValue());
                }
            }
        } catch (Exception e) {
            // 异步链路异常会被吞掉，这里显式记录；insertBatch 为批量事务，失败则整批不更新采样状态，下次上报会重试
            log.error("批量写入设备历史失败，丢弃 {} 条：{}", toStore.size(), e.getMessage(), e);
        }
    }

    private String samplingKey(DeviceHistory history) {
        return history.getProductId() + ':' + history.getDeviceId() + ':' + history.getTelemetryKey();
    }
}
