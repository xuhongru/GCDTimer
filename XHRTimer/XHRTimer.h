//
//  XHRTimer.h
//  自定义封装GCD定时器
//
//  Created by 胥鸿儒 on 16/8/10.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHR_dispatch_timer;
@interface XHRTimer : NSObject
//通过block传出的timer是用来解决block的循环引用问题
//初始化定时器,默认初始化完成后开启
+ (void)timerWithTimeInterval:(NSTimeInterval)timeInterval  dispatchQueue:(dispatch_queue_t)dispatchQueue withBlock:(void(^)(XHR_dispatch_timer *))block;
//通过block传出的timer是用来解决block的循环引用问题
//初始化定时器,需要手动开启
+ (void)timerWithTimeInterval:(NSTimeInterval)timeInterval  dispatchQueue:(dispatch_queue_t)dispatchQueue isOn:(BOOL)isOn withBlock:(void(^)(XHR_dispatch_timer *))block;
//暂停定时器
+ (void)suspend:(XHR_dispatch_timer *)timer;
+ (void)suspendAllTimer;
//取消定时器
+ (void)cancel:(XHR_dispatch_timer *)timer;
+ (void)cancelAllTimer;
//开启定时器
+ (void)resumeAllTimer;
+ (void)resume:(XHR_dispatch_timer *)timer;
@end
