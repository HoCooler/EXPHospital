//
//  EXPDataReaderModel.h
//  ExposeHospital
//
//  Created by HoCooler on 16/5/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXPDataReaderDelegate.h"

@interface EXPDataReaderModel : NSObject

@property (nonatomic, weak) id<EXPDataReaderDelegate> delegate;

- (void)startLoadLocalAnnotations;

- (void)stopLoadLocalAnnotations;

@end
