package com.ruoyi.iot.task;

import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateTime;
import com.ruoyi.iot.mapper.PartitionMapper;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 设备历史数据表的分区维护任务。
 *
 * <p>历史数据采集已改为事件驱动（DeviceStateListener / DeviceBindingListener -> DeviceHistoryEvent
 * -> DeviceHistoryListener 节流落库），本类仅保留 device_history 表按月 RANGE 分区的预创建，
 * 不再做轮询快照落库。
 */
@Slf4j
@Component
public class DeviceHistoriesTask {

    @Autowired
    private PartitionMapper partitionMapper;

    public static final String DEVICE_HISTORY = "device_history";

    @PostConstruct
    public void init() {
        deviceHistoryPartitions();
    }

    @Scheduled(cron = "0 0 2 * * ?")
    public void createPartitions() {
        deviceHistoryNextPartitions();
    }


    public void deviceHistoryPartitions() {
        DateTime now = DateTime.now();
        String partitionName = "p" + now.toString("yyyyMM");
        Integer count = partitionMapper.checkPartitionExists(DEVICE_HISTORY, partitionName);

        DateTime nextMonth = now.offset(DateField.MONTH, 1);
        nextMonth.setField(DateField.DAY_OF_MONTH, 1);

        String partitionValue = nextMonth.toString("yyyy-MM-dd");

        if (count == 0) {
            partitionMapper.createMonthPartition(DEVICE_HISTORY, partitionName, partitionValue);
            //创建历史记录分区日志
            log.info("创建表格{}，分区{}，时间为{}", DEVICE_HISTORY, partitionName, partitionValue);
        }
    }

    public void deviceHistoryNextPartitions() {
        DateTime now = DateTime.now().offset(DateField.MONTH, 1);
        String partitionName = "p" + now.toString("yyyyMM");
        Integer count = partitionMapper.checkPartitionExists(DEVICE_HISTORY, partitionName);

        DateTime nextMonth = now.offset(DateField.MONTH, 1);
        nextMonth.setField(DateField.DAY_OF_MONTH, 1);

        String partitionValue = nextMonth.toString("yyyy-MM-dd");

        if (count == 0) {
            partitionMapper.createMonthPartition(DEVICE_HISTORY, partitionName, partitionValue);
            log.info("创建表格{}，分区{}，时间为{}", DEVICE_HISTORY, partitionName, partitionValue);
        }
    }

}
