//
//  EXPDetailNewsInfoView.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/26.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPDetailNewsInfoView.h"
#import "EXPMKPointAnnotation.h"
#import "EXPDetailNewsCell.h"

static NSString * const kEXPDetailNewsCellIdentify = @"kEXPDetailNewsCellIdentify";

@interface EXPDetailNewsInfoView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EXPDetailNewsInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[EXPDetailNewsCell class] forCellReuseIdentifier:kEXPDetailNewsCellIdentify];
    [self addSubview:self.tableView];
}


- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, dataSource.count * EXPDetailCellHeight);

        [self.tableView reloadData];
    }
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EXPDetailCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EXPDetailNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kEXPDetailNewsCellIdentify];
    if (!cell) {
        cell = [[EXPDetailNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEXPDetailNewsCellIdentify];
    }
    cell.info = self.dataSource[indexPath.row];
    return cell;
}
@end
