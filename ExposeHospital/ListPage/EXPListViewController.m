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

@interface EXPListViewController()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *hospitalArray;
@property (nonatomic, strong) NSMutableArray *filterArray;

@property (nonatomic, strong) EXPDataReaderModel *model;

@end

@implementation EXPListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"输入医院名";
    
    self.model = [EXPDataReaderModel defaultDataReaderModel];
    self.hospitalArray = [self.model getLocalAnnotations];
    
    [self.model.annotationChangedSignal subscribeNext:^(NSArray *array) {
        self.hospitalArray = array;
        if (!self.searchController.active) {
            [self.tableView reloadData];
        }
    }];
    
    [self setupSearchBar];

    [self setupTableView];
    
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
}

- (void)setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_search_headBar"];
    [self.searchBar setImage:[UIImage imageNamed:@"icon_search_glass"]
                forSearchBarIcon:UISearchBarIconSearch
                           state:UIControlStateNormal];
    [self.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"bg_search_field"]
                                                       resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)]
                                             forState:UIControlStateNormal];
    self.searchBar.placeholder = @"城市/行政区/拼音";
    self.searchBar.accessibilityLabel = @"城市/行政区/拼音";
    self.searchBar.showsScopeBar = YES;
    [self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(10, 0)];
    
    self.tableView.tableHeaderView = self.searchBar;
;
//    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    [self addChildViewController:self.searchController];
    [self.searchController didMoveToParentViewController:self];
    
    self.searchController.delegate = self;
//    self.searchController.view.frame = self.view.bounds;
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchController.active) {
        return self.hospitalArray.count;
    } else {
        return self.filterArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HospitalCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];
    cell.textLabel.text = annotation.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];

    EXPHosptialDetailViewController *detailVC = [[EXPHosptialDetailViewController alloc] initWithAnnotation:annotation];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    EXPMKPointAnnotation *annotation = [self getDataSourceWithIndexPath:indexPath];
    EXPHomePageViewController *homeVC = [[EXPHomePageViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (EXPMKPointAnnotation *)getDataSourceWithIndexPath: (NSIndexPath *)indexPath
{
    EXPMKPointAnnotation *annotation = nil;
    if (!self.searchController.active) {
        annotation = self.hospitalArray[indexPath.row];
    } else {
        annotation = self.filterArray[indexPath.row];
    }
    return annotation;
}

#pragma mark searchController delegate
@end
