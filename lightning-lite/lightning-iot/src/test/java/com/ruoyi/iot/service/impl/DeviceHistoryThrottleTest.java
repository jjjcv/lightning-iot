package com.ruoyi.iot.service.impl;

import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.service.IProductsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class DeviceHistoryThrottleTest {

    private static final String PRODUCT_ID = "product-1";
    private static final String SAMPLE_KEY = PRODUCT_ID + ":device-1:temperature";

    private IProductsService productsService;
    private DeviceHistoryThrottle throttle;
    private AtomicReference<Product> product;

    @BeforeEach
    void setUp() {
        productsService = mock(IProductsService.class);
        product = new AtomicReference<>(product("enable", 1_000L));
        when(productsService.selectProductsById(PRODUCT_ID)).thenAnswer(invocation -> product.get());
        throttle = new DeviceHistoryThrottle(productsService);
    }

    @Test
    void disablingProductClearsSamplesAndRejectsFurtherUpdates() {
        assertTrue(throttle.isProductEnabled(PRODUCT_ID));
        throttle.update(PRODUCT_ID, SAMPLE_KEY, 100L, "20");
        assertNotNull(throttle.get(SAMPLE_KEY));

        product.set(product("disable", 1_000L));
        throttle.onProductStatusChanged(PRODUCT_ID, "disable");

        assertFalse(throttle.isProductEnabled(PRODUCT_ID));
        assertNull(throttle.get(SAMPLE_KEY));

        throttle.update(PRODUCT_ID, SAMPLE_KEY, 200L, "21");
        assertNull(throttle.get(SAMPLE_KEY));
    }

    @Test
    void enablingProductImmediatelyRefreshesItsStatus() {
        product.set(product("disable", 1_000L));
        assertFalse(throttle.isProductEnabled(PRODUCT_ID));

        product.set(product("enable", 2_000L));
        throttle.onProductStatusChanged(PRODUCT_ID, "enable");

        assertTrue(throttle.isProductEnabled(PRODUCT_ID));
        assertTrue(throttle.getStorageInterval(PRODUCT_ID) == 2_000L);
    }

    @Test
    void staleProductLoadCannotOverwriteConcurrentDisable() throws Exception {
        CountDownLatch queryStarted = new CountDownLatch(1);
        CountDownLatch releaseQuery = new CountDownLatch(1);
        AtomicBoolean firstQuery = new AtomicBoolean(true);
        when(productsService.selectProductsById(PRODUCT_ID)).thenAnswer(invocation -> {
            if (firstQuery.compareAndSet(true, false)) {
                queryStarted.countDown();
                assertTrue(releaseQuery.await(5, TimeUnit.SECONDS));
            }
            return product("enable", 1_000L);
        });

        AtomicBoolean enabled = new AtomicBoolean(true);
        Thread loader = new Thread(() -> enabled.set(throttle.isProductEnabled(PRODUCT_ID)));
        loader.start();
        assertTrue(queryStarted.await(5, TimeUnit.SECONDS));

        throttle.onProductStatusChanged(PRODUCT_ID, "disable");
        releaseQuery.countDown();
        loader.join(5_000L);

        assertFalse(loader.isAlive());
        assertFalse(enabled.get());
        assertFalse(throttle.isProductEnabled(PRODUCT_ID));
    }

    private Product product(String status, long storageInterval) {
        Product value = new Product();
        value.setId(PRODUCT_ID);
        value.setStatus(status);
        value.setStorageInterval(storageInterval);
        return value;
    }
}
