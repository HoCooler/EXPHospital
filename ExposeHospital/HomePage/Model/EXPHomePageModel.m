//
//  EXPHomePageModel.m
//  ExposeHospital
//
//  Created by HoCooler on 16/5/15.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPHomePageModel.h"

@interface EXPHomePageModel()
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@end

@implementation EXPHomePageModel

- (RACSignal *)fetchNetworkAnnotions
{
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		self.subscriber = subscriber;
//		[self startLoadLocalAnnotations];
		
		return [RACDisposable disposableWithBlock:^{
			;
		}];
	}];
}

@end
