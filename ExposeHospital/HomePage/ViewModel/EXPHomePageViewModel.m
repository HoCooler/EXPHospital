//
//  EXPHomePageViewModel.m
//  ExposeHospital
//
//  Created by HoCooler on 16/5/15.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPHomePageViewModel.h"
#import "EXPHomePageModel.h"

@interface EXPHomePageViewModel()

@property (nonatomic, strong) EXPHomePageModel *model;
@end

@implementation EXPHomePageViewModel

- (RACCommand *)fetchAnnotations
{
	if (_fetchAnnotations) {
		_fetchAnnotations = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[[self.model fetchNetworkAnnotions] doNext:^(id x) {
					[subscriber sendNext:x];
				}];
				return [RACDisposable disposableWithBlock:^{
					;
				}];
			}];
			return self.annotationsSignal;
		}];
	}
	return _fetchAnnotations;
}

- (RACSubject *)annotationsSignal
{
	if (!_annotationsSignal) {
		_annotationsSignal = [RACSubject subject];
	}
	return _annotationsSignal;
}


@end
