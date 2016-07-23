//
//  EXPDataReaderModel.m
//  ExposeHospital
//
//  Created by HoCooler on 16/5/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPDataReaderModel.h"
#import "EXPMKPointAnnotation.h"

#define BATCH_COUNT 100
#define DELAY_BETWEEN_BATCHES 0.3

@interface EXPDataReaderModel()
@property (strong,nonatomic) NSOperationQueue *operationQueue;

//tmp method
@property (nonatomic, strong) NSMutableArray *annotationArray;

@end

@implementation EXPDataReaderModel

- (instancetype)init
{
	if (self = [super init]) {
		_operationQueue = [[NSOperationQueue alloc] init];
		_operationQueue.maxConcurrentOperationCount = 1;
        _annotationArray = [NSMutableArray array];
        _annotationChangedSignal = [RACSubject subject];
	}
	return self;
}

+ (EXPDataReaderModel *)defaultDataReaderModel
{
    static EXPDataReaderModel *defaultModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultModel = [[self alloc] init];
    });
    return defaultModel;
}

- (void)startLoadLocalAnnotations
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSString *file = [NSBundle.mainBundle pathForResource:@"dataArray" ofType:@"json"];
		NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:file];
		[inputStream open];
		NSError *error = nil;
		NSArray *dataAsJson = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:&error];
		if (error) {
			NSLog(@"%@",error);
		}
		
		NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:BATCH_COUNT];
		for (NSDictionary *annotationAsJSON in dataAsJson) {
				// Convert JSON into annotation object
			EXPMKPointAnnotation *annotation = [[EXPMKPointAnnotation alloc] init];
			id location = [annotationAsJSON valueForKeyPath:@"location"];
			NSString *name = [annotationAsJSON valueForKeyPath:@"name"];
			if (name.length > 0 && [location isKindOfClass:[NSDictionary class]]) {
				NSString *latitudeAsString = [annotationAsJSON valueForKeyPath:@"location.lat"];
				NSString *longitudeAsString = [annotationAsJSON valueForKeyPath:@"location.lng"];
				if (latitudeAsString.length > 0 && longitudeAsString.length > 0) {
					annotation.coordinate = CLLocationCoordinate2DMake(latitudeAsString.doubleValue, longitudeAsString.doubleValue);
					annotation.title = name;
					[annotations addObject:annotation];
				}
			}
			
			if (annotations.count == BATCH_COUNT) {
					// Dispatch batch of annotations
				[self dispatchAnnotations:annotations];
				[annotations removeAllObjects];
			}
		}
			// Dispatch remaining annotations
		[self dispatchAnnotations:annotations];
	});
}

- (void)stopLoadLocalAnnotations
{
	[self.operationQueue cancelAllOperations];
}

- (void)dispatchAnnotations:(NSArray *)annotations
{
    [self.annotationArray addObjectsFromArray:annotations];
    [self.annotationChangedSignal sendNext:self.annotationArray];
    
    // Dispatch on main thread with some delay to simulate network requests
	NSArray *annotationsToDispatch = [annotations copy];
	[self.operationQueue addOperationWithBlock:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			if ([self.delegate respondsToSelector:@selector(dataReader:addAnnotations:)]) {
				[self.delegate dataReader:self addAnnotations:annotationsToDispatch];
			}
		});
		[NSThread sleepForTimeInterval:DELAY_BETWEEN_BATCHES];
	}];
}

- (NSArray *)getLocalAnnotations
{
    return [self.annotationArray copy];
}
@end
