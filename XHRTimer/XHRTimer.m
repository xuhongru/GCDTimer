//
//  XHRTimer.m
//  自定义封装GCD定时器
//
//  Created by 胥鸿儒 on 16/8/10.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import "XHRTimer.h"
typedef NS_ENUM(NSInteger, XHR_dispatch_timerStatus)
{
    XHR_dispatch_timerStatusSuspend,
    XHR_dispatch_timerStatusCanceled,
    XHR_dispatch_timerStatusRuning,
};
@interface XHR_dispatch_timer : NSObject
/**timer*/
@property(nonatomic,strong)dispatch_source_t timer;
/**timer的运行状态*/
@property(nonatomic,assign)XHR_dispatch_timerStatus timerStatus;
@end

@implementation XHR_dispatch_timer
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval  dispatchQueue:(dispatch_queue_t)dispatchQueue withBlock:(void(^)(XHR_dispatch_timer *))block
{
    if (self = [super init]) {
        //timer本质也是对象必须有强应用引用,不然就会被释放
         self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
        //设置开始时间和时间间隔
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        //设置回调时间
        dispatch_source_set_event_handler(self.timer, ^{
            block(self);
        });
        self.timerStatus = XHR_dispatch_timerStatusSuspend;
    }
    return self;
}
- (void)setTimerStatus:(XHR_dispatch_timerStatus)timerStatus
{
    if (!self.timer) return;
    if (timerStatus == XHR_dispatch_timerStatusSuspend && _timerStatus != XHR_dispatch_timerStatusSuspend) {
        dispatch_suspend(self.timer);
    }
    else if (timerStatus == XHR_dispatch_timerStatusRuning && _timerStatus == XHR_dispatch_timerStatusSuspend)
    {
        dispatch_resume(self.timer);
    }
    else if(timerStatus == XHR_dispatch_timerStatusCanceled && _timerStatus != XHR_dispatch_timerStatusCanceled)
    {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    _timerStatus = timerStatus;
}

@end

@implementation XHRTimer
static NSMutableDictionary *timerDictionary;
static NSInteger timerIndex = 0;
+ (NSMutableDictionary *)timerDictionary
{
    if (!timerDictionary) {
        timerDictionary = [NSMutableDictionary dictionary];
    }
    return timerDictionary;
}
//初始化定时器
+ (void)timerWithTimeInterval:(NSTimeInterval)timeInterval  dispatchQueue:(dispatch_queue_t)dispatchQueue withBlock:(void (^)(XHR_dispatch_timer *))block
{
    //默认方法自动开启定时器
    [self timerWithTimeInterval:timeInterval dispatchQueue:dispatchQueue isOn:YES withBlock:block];
}
+ (void)timerWithTimeInterval:(NSTimeInterval)timeInterval  dispatchQueue:(dispatch_queue_t)dispatchQueue isOn:(BOOL)isOn withBlock:(void (^)(XHR_dispatch_timer *))block
{
    XHR_dispatch_timer *timer = [[XHR_dispatch_timer alloc]initWithTimeInterval:timeInterval dispatchQueue:dispatchQueue withBlock:block];
    
    [self.timerDictionary setObject:timer forKey:[NSString stringWithFormat:@"timerIndex_%ld",timerIndex++]];
    //根据设置是否需要在初始化完成后开启
    if (isOn) {
        timer.timerStatus = XHR_dispatch_timerStatusRuning;
    }
}
//暂停定时器
+ (void)suspend:(XHR_dispatch_timer *)timer
{
    if (timer) {
        timer.timerStatus = XHR_dispatch_timerStatusSuspend;
    }
}
+ (void)suspendAllTimer
{
    [self.timerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, XHR_dispatch_timer *_Nonnull obj, BOOL * _Nonnull stop) {
        obj.timerStatus = XHR_dispatch_timerStatusSuspend;
    }];
}
//取消定时器
+ (void)cancel:(XHR_dispatch_timer *)timer
{
    if (timer) {
        timer.timerStatus = XHR_dispatch_timerStatusCanceled;
    }
    [self.timerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:timer]) {
            [self.timerDictionary removeObjectForKey:key];
            return;
        }
    }];
}
+ (void)cancelAllTimer
{
    [self.timerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, XHR_dispatch_timer  *_Nonnull obj, BOOL * _Nonnull stop) {
        obj.timerStatus = XHR_dispatch_timerStatusCanceled;
    }];
    [self.timerDictionary removeAllObjects];
}
//手动开启/继续 定时器
+ (void)resume:(XHR_dispatch_timer *)timer
{
    if (timer) {
        timer.timerStatus = XHR_dispatch_timerStatusRuning;
    }
}
+ (void)resumeAllTimer
{
    [self.timerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, XHR_dispatch_timer *_Nonnull obj, BOOL * _Nonnull stop) {
        obj.timerStatus = XHR_dispatch_timerStatusRuning;
    }];
}
@end
