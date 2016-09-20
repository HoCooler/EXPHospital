//
//  EXPDataReaderDelegate.h
//  ExposeHospital
//
//  Created by HoCooler on 16/5/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EXPDataReaderModel;

@protocol EXPDataReaderDelegate <NSObject>

- (void)dataReader:(EXPDataReaderModel *)dataReader addAnnotations:(NSArray *)annotations;

@end
