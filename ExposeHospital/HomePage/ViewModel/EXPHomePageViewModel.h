//
//  EXPHomePageViewModel.h
//  ExposeHospital
//
//  Created by HoCooler on 16/5/15.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXPHomePageViewModel : NSObject

@property (nonatomic, strong) RACCommand *fetchAnnotations;
@property (nonatomic, strong) RACSubject *annotationsSignal;
//@property (nonatomic, strong) RACCommand *fetchLocalAnnotations;

- (void)startLoadLocalAnnotions;
- (void)stopLoadLoaclAnnotions;

@end
