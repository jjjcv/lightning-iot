package com.ruoyi.iot.init;

import com.ruoyi.iot.domain.EdgeDevice;
import com.ruoyi.iot.edge.EdgeAdapter;
import com.ruoyi.iot.edge.EdgeAdapterManager;
import com.ruoyi.iot.service.IEdgeDeviceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;


@Slf4j
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class StartupTaskApplicationRunner implements ApplicationRunner {

    @Autowired
    private IEdgeDeviceService edgeDeviceService;

    @Autowired
    private EdgeAdapterManager edgeAdapterManager;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        initEdgeAdapters();
    }


    public void initEdgeAdapters(){
        EdgeDevice edgeDevice = new EdgeDevice();
        edgeDevice.setStatus("enable");
        List<EdgeDevice> edgeDevices = edgeDeviceService.selectEdgeDeviceList(edgeDevice);
        // 单个网关初始化失败不影响其它网关启动
        for (EdgeDevice device : edgeDevices) {
            try {
                edgeAdapterManager.createAndInitialize(device);
            } catch (Exception e) {
                log.error("边缘网关{}初始化失败，跳过：", device.getId(), e);
            }
        }
        edgeAdapterManager.getAdapters().forEach(EdgeAdapter::enable);
    }

}
