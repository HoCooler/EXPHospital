//
//  EXPDetailNewsInfoView.h
//  ExposeHospital
//
//  Created by HoCooler on 16/8/26.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPDetailNewsInfoView : UIView

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSString *headString;
 
- (void)reloadData;

@end
