//
//  ViewController.m
//  自定义封装GCD定时器
//
//  Created by 胥鸿儒 on 16/8/10.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import "ViewController.h"
#import "XHRTimer.h"
@interface ViewController ()

/**timer*/
@property(nonatomic,strong)XHR_dispatch_timer *timer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [XHRTimer timerWithTimeInterval:1 dispatchQueue:dispatch_get_main_queue() withBlock:^(XHR_dispatch_timer *timer){
        _timer = timer;
        NSLog(@"定时器开始工作");
    }];
 

}
- (IBAction)start:(UIButton *)sender {
    [XHRTimer resume:self.timer];
}
- (IBAction)suspend:(id)sender {

    [XHRTimer suspend:self.timer];
}
- (IBAction)cancel:(id)sender {
    [XHRTimer cancelAllTimer];
}


@end
