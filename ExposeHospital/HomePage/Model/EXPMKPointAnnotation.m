//
//  EXPMKPointAnnotation.m
//  ExposeHospital
//
//  Created by HoCooler on 16/6/3.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPMKPointAnnotation.h"
#import "EXPEvidenceInfo.h"

@implementation EXPExtraInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    EXPExtraInfo *info = [[EXPExtraInfo alloc] init];
    return @{@keypath(info, confirm): @"confirm",
              @keypath(info, evidences): @"evidence"
             };
}

+ (NSValueTransformer *)evidencesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
        return [MTLJSONAdapter modelsOfClass:[EXPEvidenceInfo class] fromJSONArray:array error:nil];
    }];
}

@end

@implementation EXPMKPointBaseInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    EXPMKPointBaseInfo *info = [[EXPMKPointBaseInfo alloc] init];
    return @{@keypath(info, dataVersion): @"dataversion",
              @keypath(info, USID): @"USID",
              @keypath(info, creatTime): @"created",
              @keypath(info, updateTime): @"updated",
              @keypath(info, name): @"name",
              @keypath(info, city): @"city",
              @keypath(info, province): @"province",
              @keypath(info, address): @"address",
              @keypath(info, lat): @"location.lat",
              @keypath(info, lng): @"location.lng",
              @keypath(info, phones): @"phone",
//              @keypath(info, baiduAD): @"baiduad",
              @keypath(info, hospitalNews): @"news",
              @keypath(info, putian): @"putian",
              @keypath(info, comments): @"comments",
             };
}

+ (NSValueTransformer *)hospitalNewsJSONTransformer
{
//    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
//        return [[[array rac_sequence] map:^id(NSDictionary *dict) {
//            return [MTLJSONAdapter modelOfClass:[EXPExtraInfo class] fromJSONDictionary:dict error:nil];
//        }] array];
//    }];
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dict) {
        return [MTLJSONAdapter modelOfClass:[EXPExtraInfo class] fromJSONDictionary:dict error:nil];
    }];
}

+ (NSValueTransformer *)updateTimeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *time) {
        return [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
    }];
}

+ (NSValueTransformer *)putianJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dict) {
        return [MTLJSONAdapter modelOfClass:[EXPExtraInfo class] fromJSONDictionary:dict error:nil];
    }];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dict) {
        return [MTLJSONAdapter modelOfClass:[EXPExtraInfo class] fromJSONDictionary:dict error:nil];
    }];
}

@end

@implementation EXPMKPointAnnotation

@end
