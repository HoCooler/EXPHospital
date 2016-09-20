//
//  EXPDelayTimer.h
//  ExposeHospital
//
//  Created by HoCooler on 16/8/7.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXPDelayTimer : NSObject

//+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
+ (instancetype)delayTimer:(NSTimeInterval)ti withBlock:(void (^)())block;

- (void)restart;
@end
