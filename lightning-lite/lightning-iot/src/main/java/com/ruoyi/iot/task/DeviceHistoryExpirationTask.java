package com.ruoyi.iot.task;

import com.ruoyi.iot.domain.Product;
import com.ruoyi.iot.service.IDeviceHistoryService;
import com.ruoyi.iot.service.IProductsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

/**
 * 设备历史数据过期清理任务。
 *
 * <p>按 {@link Product#getDataExpiration()}（毫秒）清理 device_history：对每个配置了
 * dataExpiration（&gt;0）的产品，删除早于 {@code now - dataExpiration} 的历史数据。
 * 清理粒度为"产品 + 时间"，由当前存储策略（MySQL / InfluxDB）执行实际删除。
 *
 * <p>每天 02:30 执行，避开 02:00 的 device_history 分区预创建任务（{@link DeviceHistoriesTask}）。
 * 多实例部署下 @Scheduled 会被各实例分别执行，DELETE 幂等，不引入分布式锁。
 */
@Slf4j
@Component
public class DeviceHistoryExpirationTask {

    @Autowired
    private IProductsService productsService;

    @Autowired
    private IDeviceHistoryService deviceHistoryService;

    @Scheduled(cron = "0 30 2 * * ?")
//    @Scheduled(cron = "*/10 * * * * ?")
    public void cleanupExpiredHistory() {
        List<Product> products;
        try {
            products = productsService.selectProductsList(new Product());
        } catch (Exception e) {
            log.error("查询产品列表失败，跳过本次过期历史清理", e);
            return;
        }
        if (products == null || products.isEmpty()) {
            return;
        }

        long now = System.currentTimeMillis();
        int processed = 0;
        int skipped = 0;
        int failed = 0;

        for (Product product : products) {
            String productId = product.getId();
            Long dataExpiration = product.getDataExpiration();
            if (productId == null || productId.isEmpty()
                    || dataExpiration == null || dataExpiration <= 0L) {
                skipped++;
                continue;
            }

            Date cutoff = new Date(now - dataExpiration);
            try {
                int deleted = deviceHistoryService.deleteExpiredByProduct(productId, cutoff);
                processed++;
                log.info("清理产品[{}]过期历史: cutoff={}, 删除{}条", productId, cutoff, deleted);
            } catch (Exception e) {
                failed++;
                log.error("清理产品[{}]过期历史失败", productId, e);
            }
        }

        log.info("过期历史清理完成: 处理{}个, 跳过{}个, 失败{}个", processed, skipped, failed);
    }
}
