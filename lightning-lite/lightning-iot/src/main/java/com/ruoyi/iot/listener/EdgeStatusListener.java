package com.ruoyi.iot.listener;


import com.ruoyi.iot.event.EdgeStatusEvent;
import com.ruoyi.iot.service.ConnectionStatusStore;
import org.springframework.context.ApplicationListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Component
public class EdgeStatusListener implements ApplicationListener<EdgeStatusEvent> {

    private final ConnectionStatusStore connectionStatusStore;

    public EdgeStatusListener(ConnectionStatusStore connectionStatusStore) {
        this.connectionStatusStore = connectionStatusStore;
    }

    @Async("virtualThreadExecutor")
    @Override
    public void onApplicationEvent(EdgeStatusEvent event) {
        Boolean status = event.getStatus();

        String stringStatus;
        if (status){
            stringStatus = "online";
        } else {
            stringStatus = "offline";
        }

        connectionStatusStore.updateGatewayStatus(event.getEdgeDeviceId(), stringStatus);
    }

}
