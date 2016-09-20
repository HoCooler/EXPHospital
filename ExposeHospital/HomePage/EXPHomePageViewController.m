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
#import "EXPLocationManager.h"
#import "EXPMKPointAnnotation.h"
#import "TKAlertCenter.h"

static const CGFloat kTitleViewHeight = 30.0;
static const CGFloat kLeftSearchBarWidth = 90;

@interface EXPHomePageViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) EXPHomePageViewModel *viewModel;//Fetch From Network (Not implemented)
@property (nonatomic, strong) EXPDataReaderModel *dataReader;
@property (nonatomic, strong) CCHMapClusterController *mapClusterController;
@property (nonatomic, strong) EXPMKPointAnnotation *listAnnotation;

@end

@implementation EXPHomePageViewController

- (instancetype)initWithAnnotation:(EXPMKPointAnnotation *)annotation
{
    self = [super init];
    if (self) {
        _listAnnotation = annotation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSThread sleepForTimeInterval:2.0];
    
	[self commonInit];
    
    [[EXPLocationManager defaultManager] startRequestLocation];
    
	self.view.backgroundColor = [UIColor whiteColor];
	
    if (self.listAnnotation) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.listAnnotation.coordinate, 4000, 4000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(52.516221, 13.377829);
            //        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(31.3736824,121.4971624);
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(30.752825,103.966526);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 400000, 400000);


//            CLLocation *location = [[EXPLocationManager defaultManager] getUserLocation];
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 400000, 400000);
//            [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        });
    }
    
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
    UIButton *exposoeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kTitleViewHeight)];
    [exposoeButton.titleLabel setFont:Font(15)];
    [exposoeButton.titleLabel setTextColor:[UIColor blackColor]];
    [exposoeButton setTitle:@"我要曝光" forState:UIControlStateNormal];
    [exposoeButton addTarget:self action:@selector(expose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:exposoeButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *explanationButon = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, kTitleViewHeight)];
    [explanationButon setTitle:@" 说明 " forState:UIControlStateNormal];
    [explanationButon.titleLabel setFont:Font(15)];
    [explanationButon.titleLabel setTextColor:[UIColor blackColor]];
    [explanationButon addTarget:self action:@selector(explanation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:explanationButon];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat titleViewWidth = SCREEN_WIDTH - kLeftSearchBarWidth * 2;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSearchBarWidth, 0, titleViewWidth, kTitleViewHeight)];
    
    UIControl *titleContainerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, kTitleViewHeight)];
    titleContainerControl.layer.cornerRadius = kTitleViewHeight / 2;
    titleContainerControl.layer.backgroundColor = HEXCOLOR(0xebeced).CGColor;
    [titleView addSubview:titleContainerControl];
    
    self.navigationItem.titleView = titleView;
   
    UILabel *placeholderLable = [[UILabel alloc] init];
    placeholderLable.text = @"输入医院名称";
    placeholderLable.font = Font(13);
    placeholderLable.textColor = HEXCOLOR(0x666666);
    [titleContainerControl addSubview:placeholderLable];
    [placeholderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.centerX.equalTo(titleView.mas_centerX);
        make.height.equalTo(@15);
    }];
    
    @weakify(self);
    [[titleContainerControl rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *control) {
        @strongify(self);
        EXPListViewController *listVC = [[EXPListViewController alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
    }];
}

#pragma mark Method

- (void)expose
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"曝光后台还在开发中\n尽请期待"];
}

- (void)explanation
{
    NSString *alertMessage = @"请勿完全根据应用内的数据做出您最终决定";
    NSString *message = [NSString stringWithFormat:@"本引用数据来源于网络，不能保证数据绝对可靠\n%@", alertMessage];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = [message rangeOfString:alertMessage];
    [mutableAttributeString addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:range];
    [mutableAttributeString addAttribute:NSFontAttributeName
                                   value:Font(13)
                                   range:NSMakeRange(0, message.length - alertMessage.length)];

    [mutableAttributeString addAttribute:NSFontAttributeName
                                   value:Font(16)
                                   range:range];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"说明" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:okAction];
    [alertVC setValue:mutableAttributeString forKey:@"attributedMessage"];
    [self presentViewController:alertVC animated:YES completion:nil];
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
            clusterAnnotationView.rightCalloutAccessoryView = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                UIImage *image = [UIImage imageNamed:@"icon_rightArrow"];
                [button setImage:image forState:UIControlStateNormal];
                button;
            });
		}
		
		CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
		clusterAnnotationView.count = clusterAnnotation.annotations.count;
		clusterAnnotationView.uniqueLocation = clusterAnnotation.isUniqueLocation;
        clusterAnnotationView.annotations = [clusterAnnotation.annotations copy];
        
		annotationView = clusterAnnotationView;
	}
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView setRegion:[self.mapView regionThatFits:mapView.region] animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view isKindOfClass:[EXPClusterAnnotationView class]]) {
        EXPClusterAnnotationView *annotationView = (EXPClusterAnnotationView *)view;
        NSArray *annotations = [annotationView.annotations allObjects];
        EXPListViewController *listVC = [[EXPListViewController alloc] initWithHospitals:annotations];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLocation.title = @"";
}
@end
