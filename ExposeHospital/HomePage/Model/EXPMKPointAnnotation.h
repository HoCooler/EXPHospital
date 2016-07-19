//
//  EXPMKPointAnnotation.h
//  ExposeHospital
//
//  Created by HoCooler on 16/6/3.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "EXPEvidenceInfo.h"


//typeof NS_ENUM(NSInteger, EXPConfirmStatus) {
//	EXPConfirmYES = 1,
//	EXPConfirmNO,
//	EXPConfirmUnknown
//};

@interface EXPExtraInfo : NSObject
@property (nonatomic, assign) NSInteger confirm; //是否投放 Yes/No/null/
@property (nonatomic, copy) NSArray <EXPEvidenceInfo *> *evidences;
@end

@interface EXPMKPointAnnotation : MKPointAnnotation

@property (nonatomic, copy) NSString *dataVersion;
@property (nonatomic, copy) NSString *creatTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, assign) NSInteger *USID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, assign) NSInteger cityID; //compute
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *type; //should use enum
@property (nonatomic, assign) CLLocationCoordinate2D hospitalCoordinate; //computer
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *principal;
@property (nonatomic, copy) NSArray <NSString *> *shareholder;
@property (nonatomic, copy) NSArray <NSURL *> *url;
@property (nonatomic, copy) NSArray <NSString *> *phones;
@property (nonatomic, strong) EXPExtraInfo *baiduAD;
@property (nonatomic, strong) EXPExtraInfo *hospitalNews;
@property (nonatomic, strong) EXPExtraInfo *putian;
@property (nonatomic, strong) EXPExtraInfo *comments;

@end
