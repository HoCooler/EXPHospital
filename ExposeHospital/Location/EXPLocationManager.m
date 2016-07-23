//
//  EXPLocationManager.m
//  ExposeHospital
//
//  Created by HoCooler on 16/7/20.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPLocationManager.h"

@interface EXPLocationManager()

@property (nonatomic, strong) CLLocation *location;

@end

@implementation EXPLocationManager

+ (EXPLocationManager *)defaultManager
{
    static EXPLocationManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    void (^initBlock)() = ^{
        dispatch_once(&onceToken, ^{
            defaultManager = [[self alloc] init];
            if ([defaultManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [defaultManager requestWhenInUseAuthorization];
            }
        });
    };
    
    //Init in Main Thread or the active run loop
    if ([NSThread isMainThread]) {
        initBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), initBlock);
    }
    
    return defaultManager;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;
    if (location) {
        self.location = location;
#ifdef DEBUG
        NSLog(@"Current location:%@",location);
#endif
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.location = nil;
#ifdef DEBUG
    NSLog(@"Error finding location:%@",error.localizedDescription);
#endif
}

- (CLLocation *)getUserLocation
{
    return self.location;
}
@end
