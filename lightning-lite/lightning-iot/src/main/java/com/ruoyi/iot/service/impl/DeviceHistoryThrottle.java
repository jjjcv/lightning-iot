package com.ruoyi.iot.service.impl;

import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.service.IProductsService;
import org.springframework.stereotype.Component;

import java.util.concurrent.ConcurrentHashMap;

/**
 * 设备历史数据采样节流器（内存态，单实例）。
 *
 * <p>按点位记录“上次入库时间 / 上次入库值”，供 {@link com.ruoyi.iot.listener.DeviceHistoryListener}
 * 做“上报即落库 / 变化且间隔达标”判定：
 * <ul>
 *   <li>{@code storageInterval <= 0}：上报即落库，每条都存；</li>
 *   <li>{@code storageInterval > 0}：仅当 value 与上次入库值不同、且距上次入库已达间隔才存。</li>
 * </ul>
 *
 * <p>同时缓存每个产品的 {@code storageInterval} 与启停状态。只有启用产品允许写入历史；
 * 产品停用时会清除其全部点位的采样状态，重新启用后将从新的采样周期开始。
 * 缓存带 {@link #PRODUCT_TTL_MILLIS} TTL 平衡新鲜度与性能。
 *
 * <p><b>多实例部署下内存态不共享，会出现重复入库</b>；如需集群一致应改用 Redis 维护采样状态。
 */
@Component
public class DeviceHistoryThrottle {

    /** 单点采样状态：上次入库墙钟时间 + 上次入库值 */
    public static final class Sample {
        private volatile long lastStoreTime;
        private volatile String lastValue;

        Sample(long lastStoreTime, String lastValue) {
            this.lastStoreTime = lastStoreTime;
            this.lastValue = lastValue;
        }

        public long getLastStoreTime() {
            return lastStoreTime;
        }

        public String getLastValue() {
            return lastValue;
        }
    }

    /** 产品本地缓存条目：存储间隔 + 启停状态 + 抓取时间 */
    private static final class ProductEntry {
        final long interval;
        final boolean enabled;
        final long fetchedAt;

        ProductEntry(long interval, boolean enabled, long fetchedAt) {
            this.interval = interval;
            this.enabled = enabled;
            this.fetchedAt = fetchedAt;
        }
    }

    /** 产品配置缓存刷新周期 */
    private static final long PRODUCT_TTL_MILLIS = 60_000L;

    private final IProductsService productsService;

    /** key = productId:deviceId:telemetryKey */
    private final ConcurrentHashMap<String, Sample> samples = new ConcurrentHashMap<>();

    /** 产品配置本地缓存（带 TTL） */
    private final ConcurrentHashMap<String, ProductEntry> productCache = new ConcurrentHashMap<>();

    public DeviceHistoryThrottle(IProductsService productsService) {
        this.productsService = productsService;
    }

    /**
     * 获取点位上次采样状态。
     *
     * @param key {@code productId:deviceId:telemetryKey}
     * @return 采样状态；不存在返回 null
     */
    public Sample get(String key) {
        return samples.get(key);
    }

    /**
     * 更新点位采样状态（入库成功后调用）。
     *
     * @param productId 产品 ID
     * @param key   {@code productId:deviceId:telemetryKey}
     * @param now   入库墙钟时间
     * @param value 本次入库值
     */
    public void update(String productId, String key, long now, String value) {
        if (!isProductEnabled(productId)) {
            return;
        }
        Sample sample = samples.computeIfAbsent(key, k -> new Sample(now, value));
        sample.lastStoreTime = now;
        sample.lastValue = value;

        // 状态可能在上面的检查与写缓存之间发生变化；停用后不能重新留下采样缓存。
        if (!isProductEnabled(productId)) {
            clearSamples(productId);
        }
    }

    /**
     * 获取产品存储间隔（ms）。0 / null 表示上报即落库。
     *
     * <p>带本地 TTL 缓存，避免每条上报都回查产品。产品是否允许落库由
     * {@link #isProductEnabled(String)} 判断。
     */
    public long getStorageInterval(String productId) {
        return getProductEntry(productId).interval;
    }

    /**
     * 判断产品是否启用。停用或不存在的产品不允许写入历史，并清除其历史采样缓存。
     */
    public boolean isProductEnabled(String productId) {
        ProductEntry entry = getProductEntry(productId);
        if (!entry.enabled) {
            clearSamples(productId);
        }
        return entry.enabled;
    }

    /**
     * 产品状态变更成功后调用，使状态立即生效而无需等待 TTL。
     */
    public void onProductStatusChanged(String productId, String status) {
        if (productId == null || productId.isEmpty()) {
            return;
        }

        long now = System.currentTimeMillis();
        if ("enable".equals(status)) {
            // 状态更新已成功，立即重新加载并记录完整配置，无需等下一条上报触发查询。
            ProductEntry loaded = productCache.compute(productId,
                (id, previous) -> loadProductEntry(id, now));
            if (!loaded.enabled) {
                clearSamples(productId);
            }
            return;
        }

        if (!"disable".equals(status)) {
            productCache.remove(productId);
            return;
        }

        productCache.compute(productId, (id, previous) ->
            new ProductEntry(previous == null ? 0L : previous.interval, false, now));
        clearSamples(productId);
    }

    private ProductEntry getProductEntry(String productId) {
        if (productId == null || productId.isEmpty()) {
            return new ProductEntry(0L, false, 0L);
        }
        long now = System.currentTimeMillis();
        ProductEntry entry = productCache.get(productId);
        if (entry != null && now - entry.fetchedAt < PRODUCT_TTL_MILLIS) {
            return entry;
        }
        ProductEntry loaded = loadProductEntry(productId, now);

        // 仅替换本次读取到的旧条目，避免并发的停用通知被较早发起的数据库查询覆盖。
        if (entry == null) {
            ProductEntry concurrent = productCache.putIfAbsent(productId, loaded);
            return concurrent == null ? loaded : concurrent;
        }
        if (productCache.replace(productId, entry, loaded)) {
            return loaded;
        }
        return productCache.getOrDefault(productId, loaded);
    }

    private ProductEntry loadProductEntry(String productId, long fetchedAt) {
        try {
            Product product = productsService.selectProductsById(productId);
            // selectProductsById 对不存在的 id 返回 NULL_PRODUCT 占位对象（id 为 null）
            if (product == null || product.getId() == null) {
                return new ProductEntry(0L, false, fetchedAt);
            }
            Long interval = product.getStorageInterval();
            return new ProductEntry(interval == null ? 0L : interval,
                "enable".equals(product.getStatus()), fetchedAt);
        } catch (Exception e) {
            // 无法确认产品已启用时不写历史，避免停用产品因查询异常而继续落库。
            return new ProductEntry(0L, false, fetchedAt);
        }
    }

    private void clearSamples(String productId) {
        String prefix = productId + ':';
        samples.keySet().removeIf(key -> key.startsWith(prefix));
    }
}
