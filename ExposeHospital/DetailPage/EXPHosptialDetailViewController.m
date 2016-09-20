//
//  EXPHosptialDetailViewController.m
//  ExposeHospital
//
//  Created by HoCooler on 16/7/23.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPHosptialDetailViewController.h"
#import "EXPMKPointAnnotation.h"
#import "UIBarButtonItem+EXPBackItem.h"

#import "EXPDetailBaseInfoView.h"
#import "EXPDetailNewsInfoView.h"

//#import "EXPDetailNewsCell.h"

@interface EXPHosptialDetailViewController()

@property (nonatomic, strong) EXPMKPointAnnotation *annotation;

@property (nonatomic, strong) EXPDetailBaseInfoView *baseInfoView;
@property (nonatomic, strong) EXPDetailNewsInfoView *newsView;
@property (nonatomic, strong) EXPDetailNewsInfoView *putianView;
@property (nonatomic, strong) EXPDetailNewsInfoView *commentsView;

@end

@implementation EXPHosptialDetailViewController

- (id)initWithAnnotation:(EXPMKPointAnnotation *)annotation
{
    self = [super init];
    if (self) {
        _annotation = annotation;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _baseInfoView = [[EXPDetailBaseInfoView alloc] initWithAnnotation:self.annotation.info];
    [self.view addSubview:self.baseInfoView];
    
    _newsView = [[EXPDetailNewsInfoView alloc] init];
    _newsView.dataSource = self.annotation.info.hospitalNews.evidences;
    [self.view addSubview:self.newsView];
    
    _putianView = [[EXPDetailNewsInfoView alloc] init];
    _putianView.dataSource = self.annotation.info.putian.evidences;
    [self.view addSubview:self.putianView];
    
    _commentsView = [[EXPDetailNewsInfoView alloc] init];
    _commentsView.dataSource = self.annotation.info.comments.evidences;
    [self.view addSubview:self.commentsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(0xeae4df);
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = self.annotation.info.name ?: @"曝光医院资料";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem exp_leftBarButtonItemWithImage:[UIImage imageNamed:@"icon_navigation_back"] highlightImage:nil target:self action:@selector(goBack)];
    
    [self.view addSubview:self.baseInfoView];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateViewConstraints
{
    [self.baseInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
    
    [self.newsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.baseInfoView.mas_bottom).offset(10);
    }];
//    
//    [self.putianView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.newsView.mas_bottom).offset(20);
//    }];
//    
//    [self.commentsView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.putianView.mas_bottom).offset(20);
//    }];
//    
    [super updateViewConstraints];
}
@end
