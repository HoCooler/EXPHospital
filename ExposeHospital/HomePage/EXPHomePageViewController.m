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


static const CGFloat kTitleViewHeight = 30.0;


@interface EXPHomePageViewController ()

@property (nonatomic, strong) MKMapView *mapView;
//@property (nonatomic, strong) UIView *featureView;

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
	
//	CLLocationCoordinate2D location = CLLocationCoordinate2DMake(52.516221, 13.377829);
//	CLLocationCoordinate2D location = CLLocationCoordinate2DMake(31.3736824,121.4971624);
	
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
    self.mapView.showsBuildings = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    _dataReader = [[EXPDataReaderModel alloc] init];
    _dataReader.delegate = self;
    
    _mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    _mapClusterController.delegate = self;
    
}

- (void)loadTheNavigationBar
{
//    CGFloat titleViewWidth = SCREEN_WIDTH;
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, , kTitleViewHeight)];
//    UIControl *titleContainerControl = [[UIControl alloc] initWithFrame:CGRectMake(-kTitleViewMargin, 0, titleViewWidth, kTitleViewHeight)];
//    titleContainerControl.layer.cornerRadius = kTitleViewHeight / 2;
//    titleContainerControl.layer.backgroundColor = HEXCOLOR(0xebeced).CGColor;
//    titleContainerControl.accessibilityLabel = @"请输入搜索关键词";
//    
//    [titleView addSubview:titleContainerControl];
//    self.navigationItem.titleView = titleView;
//    
//    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kTitleViewHeight - kSearchIconSideLength) / 2, kSearchIconSideLength, kSearchIconSideLength)];
//    leftView.image = [UIImage def_imageNamed:@"icon_food_homepage_search"];
//    
//    NSString *placeholderText = @"输入商家名、品类或商圈";
//    CGFloat textColLength = [placeholderText sizeWithAttributes:@{NSFontAttributeName : Font(13)}].width;
//    CGFloat textMaxLength = titleViewWidth - kTitleViewHeight - kSearchIconSideLength - kGapBetweenSearchIconAndPlaceholder;
//    CGFloat textRealLength = MIN(textColLength, textMaxLength);
//    
//    UILabel *placeholderLable = [[UILabel alloc] initWithFrame:CGRectMake(kSearchIconSideLength + kGapBetweenSearchIconAndPlaceholder, 0, textRealLength, kTitleViewHeight)];
//    placeholderLable.text = placeholderText;
//    placeholderLable.font = Font(13);
//    placeholderLable.textColor = HEXCOLOR(0x666666);
//    
//    CGFloat iconAndTextViewWidth = kSearchIconSideLength + kGapBetweenSearchIconAndPlaceholder + textRealLength;
//    UIView *iconAndTextView = [[UIView alloc] initWithFrame:CGRectMake((titleViewWidth - iconAndTextViewWidth) / 2, 0, iconAndTextViewWidth, kTitleViewHeight)];
//    iconAndTextView.userInteractionEnabled = NO;
//    [iconAndTextView addSubview:leftView];
//    [iconAndTextView addSubview:placeholderLable];
//    [titleContainerControl addSubview:iconAndTextView];
//    
//    UIBarButtonItem *mapBarButtonItem = [UIBarButtonItem ipf_rightBarButtonItemWithType:IPFBarButtonItemTypeMap target:self action:@selector(didClickedMap)];
//    mapBarButtonItem.accessibilityLabel = @"地图";
//    self.navigationItem.rightBarButtonItem = mapBarButtonItem;
//    
//    @weakify(self);
//    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *control) {
//        @strongify(self);
//        
//        [self scrollFilterViewToTop];
//        
//        NSString *urlString = [NSString stringWithFormat:@"imeituan://www.meituan.com/search/searchViewController"];
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        NSMutableDictionary *userInfo = [@{
//                                           @"searchMode": @(MTSearchModeGroupFirst),
//                                           @"entrance": @(METSearchEntranceHomeDealList),
//                                           @"categoryID": @([self.filterViewModel.currentCategory.categoryID intValue]),
//                                           @"categoryName": self.filterViewModel.currentCategory.name ?: @"全部",
//                                           @"steCategoryID": @(kMTFoodCategoryID)
//                                           } mutableCopy];
//        CLLocation *location = [[[MTLocationManager defaultManager] lastLocation] marsLocation];
//        if (location) {
//            userInfo[@"userLocation"] = location;
//        }
//        [SAKAnalytics trackEvent:self.pageName action:@"点击搜索" label:[self.filterViewModel.currentCategory.itemName stringByAppendingString:@"-搜索"] value:nil];
//        if ([self.pageName isEqualToString:kDEFHomePageName]) {
//            [SAKEnvironment environment].entrance = [(self.originEntrance ?: @"") stringByAppendingString:@"__gfood__hsearch"];
//        }
//        self.portalContext = userInfo;
//        [SAKPortal transferFromViewController:self toURL:url completion:nil];
//    }];
//    
//    @weakify(titleContainerControl);
//    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIControl *control) {
//        @strongify(titleContainerControl);
//        titleContainerControl.layer.backgroundColor = HEXCOLOR(0xe8e8e8).CGColor;
//    }];
//    
//    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(UIControl *control) {
//        @strongify(titleContainerControl);
//        titleContainerControl.layer.backgroundColor = HEXCOLOR(0xebeced).CGColor;
//    }];
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
