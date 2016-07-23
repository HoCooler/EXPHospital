//
//  EXPLocationManager.h
//  ExposeHospital
//
//  Created by HoCooler on 16/7/20.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface EXPLocationManager : CLLocationManager<CLLocationManagerDelegate>

+ (EXPLocationManager *)defaultManager;

- (CLLocation *)getUserLocation;

@end
