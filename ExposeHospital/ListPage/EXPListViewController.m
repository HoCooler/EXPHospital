//
//  EXPListViewController.m
//  ExposeHospital
//
//  Created by HoCooler on 16/7/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPListViewController.h"
#import "EXPDataReaderModel.h"
#import "EXPMKPointAnnotation.h"
#import "EXPHosptialDetailViewController.h"
#import "EXPHomePageViewController.h"
#import "EXPDelayTimer.h"
#import "UIBarButtonItem+EXPBackItem.h"

@interface EXPListViewController()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<EXPMKPointAnnotation *> *hospitalArray;
@property (nonatomic, strong) NSMutableArray *filterArray;

@property (nonatomic, strong) EXPDataReaderModel *model;

@property (nonatomic, assign) BOOL fromMap; //Map : YES; search : NO;

@property (nonatomic, strong) EXPDelayTimer *timer;

@property (nonatomic, assign) BOOL searchActive;

@end

@implementation EXPListViewController

- (instancetype)initWithHospitals:(NSArray<EXPMKPointAnnotation *> *)hospitals
{
    self = [self init];
    if (self) {
        _hospitalArray = hospitals;
        _fromMap = YES;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _filterArray = [NSMutableArray array];
        _model = [EXPDataReaderModel defaultDataReaderModel];
        _searchActive = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem exp_leftBarButtonItemWithImage:[UIImage imageNamed:@"icon_navigation_back"] highlightImage:nil target:self action:@selector(goBack)];
    
    if (self.fromMap) {
        self.title = [NSString stringWithFormat:@"%@家医院", @([self.hospitalArray count])];
    } else {
        self.title = @"所有曝光医院";
        self.hospitalArray = [self.model getLocalAnnotations];
        [self.model.annotationChangedSignal subscribeNext:^(NSArray *array) {
            self.hospitalArray = array;
            if (![self.searchController isActive]) {
                [self.tableView reloadData];
            }
        }];
    }

    [self setupTableView];
    
    [self bindData];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindData
{
    
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"输入医院名称";
    self.searchController.searchBar.showsScopeBar = YES;
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)dealloc{
    self.searchController.searchResultsUpdater = nil;
    self.searchController.searchBar.delegate = nil;
    self.searchController.delegate = nil;
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HospitalCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 24)];
        
        UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [mapButton addTarget:self action:@selector(tapCustomAccessory:) forControlEvents:UIControlEventTouchUpInside];
        [mapButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
        [accessoryView addSubview:mapButton];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 14, 24)];
        accessoryImageView.image = [UIImage imageNamed:@"icon_rightArrow"];
        [accessoryView addSubview:accessoryImageView];
        
        cell.accessoryView = accessoryView;
    }
    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];
    cell.textLabel.text = annotation.title;
    NSInteger num = [annotation.info.hospitalNews.evidences count];
    
    NSString *detailString = num > 0 ? [NSString stringWithFormat:@"%@条曝光  ", @(num)] : @"";
    cell.detailTextLabel.text = detailString;
    cell.detailTextLabel.textColor = num > 0 ? [UIColor redColor] : [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchController resignFirstResponder];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];

    EXPHosptialDetailViewController *detailVC = [[EXPHosptialDetailViewController alloc] initWithAnnotation:annotation];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponder];

    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];
    EXPHomePageViewController *homeVC = [[EXPHomePageViewController alloc] initWithAnnotation:annotation];
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (NSArray *)getDataSource
{
    if (self.searchActive || ![self.searchController isActive]) {
        return self.hospitalArray;
    } else {
        return self.filterArray;
    }
}

- (EXPMKPointAnnotation *)getDataSourceWithIndexPath: (NSIndexPath *)indexPath
{
    EXPMKPointAnnotation *annotation = nil;
    NSArray *dataSource = [self getDataSource];
    if (dataSource.count > indexPath.row) {
        annotation = dataSource[indexPath.row];
    }
    
    return annotation;
}

- (BOOL)existController:(UIViewController *)destinationVC inNavigation:(UINavigationController *)nav;
{
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[destinationVC class]]) {
            [nav popToViewController:vc animated:YES];
            return YES;
        }
    }
    return NO;
}

- (void)tapCustomAccessory:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

#pragma mark searchController delegate
- (void)didPresentSearchController:(UISearchController *)searchController
{
    [searchController becomeFirstResponder];
    
//    self.searchActive = NO;
//    [self.tableView reloadData];
    
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [searchController resignFirstResponder];
//
//    self.searchActive = YES;
//    [self.tableView reloadData];
//    self.searchActive = NO;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    @weakify(self)
    if (self.timer) {
        [self.timer restart];
    } else {
        self.timer = [EXPDelayTimer delayTimer:0.5 withBlock:^{
            @strongify(self)
            if (self.searchController.searchBar.text.length > 0 ) {
                [self.filterArray removeAllObjects];
                NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", self.searchController.searchBar.text];
                [self.hospitalArray enumerateObjectsUsingBlock:^(EXPMKPointAnnotation * _Nonnull annotation, NSUInteger idx, BOOL * _Nonnull stop) {
                    @strongify(self)
                    if ([searchPredicate evaluateWithObject:annotation.info.name
                         ]) {
                        [self.filterArray addObject:annotation];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self.tableView reloadData];
                });
            }
        }];
    }
}

@end
