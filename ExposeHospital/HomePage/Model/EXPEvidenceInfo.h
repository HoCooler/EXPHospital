//
//  EXPEvidenceInfo.h
//  ExposeHospital
//
//  Created by HoCooler on 16/6/3.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

@interface EXPEvidenceInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *sourceURLString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *snapShotString;
@property (nonatomic, copy) NSString *dateline;

@end
