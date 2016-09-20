//
//  EXPDelayTimer.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/7.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPDelayTimer.h"

@interface EXPDelayTimer()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) void (^delayBlock)();
@property (nonatomic, assign) NSTimeInterval ti;

@end

@implementation EXPDelayTimer

+ (instancetype)delayTimer:(NSTimeInterval)ti withBlock:(void (^)())block
{
    EXPDelayTimer *delayTimer = [[self alloc] init];
    delayTimer.delayBlock = block;
    delayTimer.ti = ti;
    delayTimer.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:delayTimer selector:@selector(runCallBack) userInfo:nil repeats:NO];
    return delayTimer;
}

- (void)runCallBack
{
    if (self.delayBlock) {
        self.delayBlock();
    }
}

- (void)restart
{
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.ti target:self selector:@selector(runCallBack) userInfo:nil repeats:NO];
}

- (void)dealloc
{
    [self.timer invalidate];
    [self.timer invalidate];

    self.timer = nil;
}
@end
