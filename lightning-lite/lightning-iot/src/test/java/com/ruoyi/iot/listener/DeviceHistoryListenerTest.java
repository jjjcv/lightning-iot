package com.ruoyi.iot.listener;

import com.ruoyi.iot.domain.DeviceHistory;
import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.event.DeviceHistoryEvent;
import com.ruoyi.iot.service.IDeviceHistoryService;
import com.ruoyi.iot.service.IProductsService;
import com.ruoyi.iot.service.impl.DeviceHistoryThrottle;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

class DeviceHistoryListenerTest {

    @Test
    void disabledProductHistoryIsNotStored() {
        IDeviceHistoryService historyService = mock(IDeviceHistoryService.class);
        IProductsService productsService = mock(IProductsService.class);
        Product product = new Product();
        product.setId("product-1");
        product.setStatus("disable");
        product.setStorageInterval(1_000L);
        when(productsService.selectProductsById("product-1")).thenReturn(product);

        DeviceHistoryThrottle throttle = new DeviceHistoryThrottle(productsService);
        DeviceHistoryListener listener = new DeviceHistoryListener(historyService, throttle);
        DeviceHistory history = new DeviceHistory();
        history.setProductId("product-1");
        history.setDeviceId("device-1");
        history.setTelemetryKey("temperature");
        history.setValue("20");

        listener.onApplicationEvent(new DeviceHistoryEvent(List.of(history)));

        verifyNoInteractions(historyService);
    }
}
