package com.ruoyi.iot.service;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class AsyncService {


    @Async("virtualThreadExecutor")
    public void executeAsyncTask() {


        System.out.println(Thread.currentThread().getName() + " 执行异步任务...");
        for (int i = 0; i < 1000; i++) {
            System.out.println(i);
        }

        System.out.println(Thread.currentThread().getName() + " 执行异步任务完成");
    }

}
