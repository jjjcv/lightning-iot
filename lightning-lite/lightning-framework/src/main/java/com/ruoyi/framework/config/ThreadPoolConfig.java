package com.ruoyi.framework.config;

import com.ruoyi.common.utils.Threads;
import org.apache.commons.lang3.concurrent.BasicThreadFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.*;

/**
 * 线程池配置
 *
 * @author ruoyi
 **/
@Configuration
@EnableAsync
public class ThreadPoolConfig
{
    // 核心线程池大小
    private int corePoolSize = 50;

    // 最大可创建的线程数
    private int maxPoolSize = 200;

    // 队列最大长度
    private int queueCapacity = 1000;

    // 线程池维护线程所允许的空闲时间
    private int keepAliveSeconds = 300;

    @Bean(name = "threadPoolTaskExecutor")
    public ThreadPoolTaskExecutor threadPoolTaskExecutor()
    {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setMaxPoolSize(maxPoolSize);
        executor.setCorePoolSize(corePoolSize);
        executor.setQueueCapacity(queueCapacity);
        executor.setKeepAliveSeconds(keepAliveSeconds);
        // 线程池对拒绝任务(无线程可用)的处理策略
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        return executor;
    }

    @Bean(name = "virtualThreadExecutor")
    public Executor virtualThreadExecutor() {
        return Executors.newVirtualThreadPerTaskExecutor();
    }


    @Bean(name = "virtualScheduledExecutorService")
    public ScheduledExecutorService virtualScheduledExecutorService() {
        // 使用虚拟线程执行器替代原有的ScheduledThreadPoolExecutor
        return Executors.newScheduledThreadPool(
                Runtime.getRuntime().availableProcessors() * 16,
                Thread.ofVirtual().factory()
        );
    }

    /**
     * 执行周期性或定时任务
     */
    @Bean(name = "scheduledExecutorService")
    protected ScheduledExecutorService scheduledExecutorService()
    {
        return new ScheduledThreadPoolExecutor(corePoolSize,
            BasicThreadFactory.builder().namingPattern("schedule-pool-%d").daemon(true).build(),
            new ThreadPoolExecutor.CallerRunsPolicy())
        {
            @Override
            protected void afterExecute(Runnable r, Throwable t)
            {
                super.afterExecute(r, t);
                Threads.printException(r, t);
            }
        };
    }

    /**
     * Spring {@code @Scheduled} 任务的调度器。
     *
     * <p>显式声明 {@link TaskScheduler} 以消除多个 {@link ScheduledExecutorService} bean 带来的歧义，
     * 并复用虚拟线程调度器（{@link #virtualScheduledExecutorService()}）执行定时任务，轻量且无固定线程数上限。
     * 不影响 {@code AsyncManager} 按名引用的 {@code scheduledExecutorService}。
     */
    @Bean
    public TaskScheduler taskScheduler()
    {
        return new ConcurrentTaskScheduler(virtualScheduledExecutorService());
    }
}
