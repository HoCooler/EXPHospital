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
@property (nonatomic, strong) RACSubject *annotationChangedSignal;

- (void)startLoadLocalAnnotations;

- (void)stopLoadLocalAnnotations;

+ (EXPDataReaderModel *)defaultDataReaderModel;

- (NSArray *)getLocalAnnotations;

@end
