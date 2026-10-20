package com.ruoyi.iot.controller;

import com.ruoyi.iot.service.AsyncService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HelloWorldController {

    @Autowired
    private AsyncService asyncService;

    @GetMapping("/hello")
    public String hello() {

        System.out.printf("当前执行线程: %s%n", Thread.currentThread()) ;

        asyncService.executeAsyncTask();

        return "HELLO WORLD";

    }
}
