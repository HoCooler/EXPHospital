//
//  NSString+EXPDateTransform.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/29.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "NSString+EXPDateTransform.h"

@implementation NSString (EXPDateTransform)

+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:currentDate];
}

@end
