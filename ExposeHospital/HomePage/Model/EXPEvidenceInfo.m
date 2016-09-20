//
//  EXPEvidenceInfo.m
//  ExposeHospital
//
//  Created by HoCooler on 16/6/3.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPEvidenceInfo.h"

@implementation EXPEvidenceInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    EXPEvidenceInfo *info = [[EXPEvidenceInfo alloc] init];
    return @{@keypath(info, sourceURLString): @"url",
              @keypath(info, title): @"title",
              @keypath(info, snapShotString): @"snapshot",
              @keypath(info, dateline): @"dateline"
              };
}

@end
