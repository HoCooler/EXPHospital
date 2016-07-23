//
//  EXPHomePageViewController.m
//  ExposeHospital
//
//  Created by HoCooler on 16/5/15.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPHomePageViewController.h"
#import "EXPClusterAnnotationView.h"
#import "CCHMapClusterAnnotation.h"
#import "EXPHomepageViewModel.h"
#import "EXPDataReaderModel.h"
#import "CCHMapClusterController.h"
#import "EXPListViewController.h"

static const CGFloat kTitleViewHeight = 30.0;
static const CGFloat kSearchIconLength = 15;
static const CGFloat kGapBetweenSearchIconAndPlaceholder = 4;
static const CGFloat kLeftSearchBarWidth = 60;

@interface EXPHomePageViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) EXPHomePageViewModel *viewModel;//Fetch From Network
@property (nonatomic, strong) EXPDataReaderModel *dataReader;
@property (nonatomic, strong) CCHMapClusterController *mapClusterController;

@end

@implementation EXPHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self commonInit];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(52.516221, 13.377829);
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(31.3736824,121.4971624);
       
    });
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(30.752825,103.966526);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 400000, 400000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
	[self refresh];
}

- (void)refresh
{
	[self.mapClusterController removeAnnotations:self.mapClusterController.annotations.allObjects withCompletionHandler:NULL];
	
	for (id<MKOverlay> overlay in self.mapView.overlays) {
		[self.mapView removeOverlay:overlay];
	}
	
	[self.dataReader startLoadLocalAnnotations];
}

- (void)commonInit
{
    [self loadMapView];
    [self loadTheNavigationBar];
}

- (void)loadMapView
{
    CGRect rect=[UIScreen mainScreen].bounds;
    
    self.mapView=[[MKMapView alloc]initWithFrame:rect];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsTraffic = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    _dataReader = [EXPDataReaderModel defaultDataReaderModel];
    _dataReader.delegate = self;
    
    _mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    _mapClusterController.delegate = self;
    
}

- (void)loadTheNavigationBar
{
    CGFloat titleViewWidth = SCREEN_WIDTH - kLeftSearchBarWidth * 2;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSearchBarWidth, 0, titleViewWidth, kTitleViewHeight)];
    UIControl *titleContainerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, kTitleViewHeight)];
    titleContainerControl.layer.cornerRadius = kTitleViewHeight / 2;
    titleContainerControl.layer.backgroundColor = HEXCOLOR(0xebeced).CGColor;
    titleContainerControl.accessibilityLabel = @"请输入搜索关键词";
    
    [titleView addSubview:titleContainerControl];
    self.navigationItem.titleView = titleView;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kTitleViewHeight - kSearchIconLength) / 2, kSearchIconLength, kSearchIconLength)];
    leftView.image = [UIImage imageNamed:@"icon_food_homepage_search"];
    
    NSString *placeholderText = @"输入医院名称";
    CGFloat textColLength = [placeholderText sizeWithAttributes:@{NSFontAttributeName : Font(13)}].width;
    CGFloat textMaxLength = titleViewWidth - kTitleViewHeight - kSearchIconLength - kGapBetweenSearchIconAndPlaceholder;
    CGFloat textRealLength = MIN(textColLength, textMaxLength);
    
    UILabel *placeholderLable = [[UILabel alloc] initWithFrame:CGRectMake(kSearchIconLength + kGapBetweenSearchIconAndPlaceholder, 0, textRealLength, kTitleViewHeight)];
    placeholderLable.text = placeholderText;
    placeholderLable.font = Font(13);
    placeholderLable.textColor = HEXCOLOR(0x666666);
    
    CGFloat iconAndTextViewWidth = kSearchIconLength + kGapBetweenSearchIconAndPlaceholder + textRealLength;
    UIView *iconAndTextView = [[UIView alloc] initWithFrame:CGRectMake((titleViewWidth - iconAndTextViewWidth) / 2, 0, iconAndTextViewWidth, kTitleViewHeight)];
    iconAndTextView.userInteractionEnabled = NO;
    [iconAndTextView addSubview:leftView];
    [iconAndTextView addSubview:placeholderLable];
    [titleContainerControl addSubview:iconAndTextView];
    
    @weakify(self);
    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *control) {
        @strongify(self);
        EXPListViewController *listVC = [[EXPListViewController alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
    }];
    
    @weakify(titleContainerControl);
    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIControl *control) {
        @strongify(titleContainerControl);
        titleContainerControl.layer.backgroundColor = HEXCOLOR(0xe8e8e8).CGColor;
    }];
    
    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(UIControl *control) {
        @strongify(titleContainerControl);
        titleContainerControl.layer.backgroundColor = HEXCOLOR(0xebeced).CGColor;
    }];
}

#pragma makr DataReaderDelegate
- (void)dataReader:(EXPDataReaderModel *)dataReader addAnnotations:(NSArray *)annotations
{
	[self.mapClusterController addAnnotations:annotations withCompletionHandler:NULL];
}

#pragma mark MKMapViewDelegate
- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
	NSUInteger numAnnotations = mapClusterAnnotation.annotations.count;
	if (numAnnotations > 1) {
		return [NSString stringWithFormat:@"%tu个曝光医院", numAnnotations];
	} else {
		CCHMapClusterAnnotation *clusterAnnotation = mapClusterAnnotation.annotations.allObjects[0];
		return [clusterAnnotation valueForKey:@"title"];
	}
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
	NSUInteger numAnnotations = MIN(mapClusterAnnotation.annotations.count, 5);
	if (numAnnotations > 1) {
		NSArray *annotations = [mapClusterAnnotation.annotations.allObjects subarrayWithRange:NSMakeRange(0, numAnnotations)];
		NSArray *titles = [annotations valueForKey:@"title"];
		return [titles componentsJoinedByString:@", "];
	} else {
		return [mapClusterAnnotation.annotations.allObjects[0] valueForKey:@"subtitle"];
	}
}

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
	EXPClusterAnnotationView *clusterAnnotationView = (EXPClusterAnnotationView *)[self.mapView viewForAnnotation:mapClusterAnnotation];
	clusterAnnotationView.count = mapClusterAnnotation.annotations.count;
	clusterAnnotationView.uniqueLocation = mapClusterAnnotation.isUniqueLocation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *annotationView;
	
	if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
		static NSString *identifier = @"clusterAnnotation";
		
		EXPClusterAnnotationView *clusterAnnotationView = (EXPClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if (clusterAnnotationView) {
			clusterAnnotationView.annotation = annotation;
		} else {
			clusterAnnotationView = [[EXPClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
			clusterAnnotationView.canShowCallout = YES;
		}
		
		CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
		clusterAnnotationView.count = clusterAnnotation.annotations.count;
		clusterAnnotationView.uniqueLocation = clusterAnnotation.isUniqueLocation;
		annotationView = clusterAnnotationView;
	}
	
	return annotationView;
}
@end
