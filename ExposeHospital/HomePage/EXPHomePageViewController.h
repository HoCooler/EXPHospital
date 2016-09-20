//
//  EXPHomePageViewController.h
//  ExposeHospital
//
//  Created by HoCooler on 16/5/15.
//  Copyright © 2016年 HoCooler. All rights reserved.
//
#import "EXPDataReaderDelegate.h"
#import "CCHMapClusterControllerDelegate.h"

@class EXPMKPointAnnotation;

@interface EXPHomePageViewController : UIViewController<MKMapViewDelegate, EXPDataReaderDelegate,CCHMapClusterControllerDelegate>

- (instancetype)initWithAnnotation:(EXPMKPointAnnotation *)annotation;

@end
