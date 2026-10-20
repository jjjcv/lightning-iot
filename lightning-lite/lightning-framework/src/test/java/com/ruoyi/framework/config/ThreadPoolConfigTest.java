package com.ruoyi.framework.config;

import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.scheduling.annotation.Async;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ThreadPoolConfigTest {

    @Test
    void asyncMethodsUseVirtualThreadExecutorWithoutBlockingCaller() throws Exception {
        try (AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
             ExecutorService callerExecutor = Executors.newSingleThreadExecutor()) {
            context.register(ThreadPoolConfig.class, AsyncProbe.class);
            context.refresh();

            AsyncProbe probe = context.getBean(AsyncProbe.class);
            CountDownLatch started = new CountDownLatch(1);
            CountDownLatch release = new CountDownLatch(1);
            AtomicReference<Thread> callerThread = new AtomicReference<>();

            Future<CompletableFuture<Thread>> invocation = callerExecutor.submit(() -> {
                callerThread.set(Thread.currentThread());
                return probe.run(started, release);
            });

            CompletableFuture<Thread> asyncResult = invocation.get(1, TimeUnit.SECONDS);
            assertTrue(started.await(1, TimeUnit.SECONDS));
            assertFalse(asyncResult.isDone());

            release.countDown();
            Thread executionThread = asyncResult.get(1, TimeUnit.SECONDS);
            assertNotSame(callerThread.get(), executionThread);
            assertTrue(executionThread.isVirtual());
        }
    }

    static class AsyncProbe {

        @Async("virtualThreadExecutor")
        public CompletableFuture<Thread> run(CountDownLatch started, CountDownLatch release)
                throws InterruptedException {
            started.countDown();
            release.await();
            return CompletableFuture.completedFuture(Thread.currentThread());
        }
    }
}
