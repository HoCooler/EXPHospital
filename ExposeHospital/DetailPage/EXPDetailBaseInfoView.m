//
//  EXPDetailBaseInfoView.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/25.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPDetailBaseInfoView.h"
#import "EXPMKPointAnnotation.h"
#import "EXPCustomLabelView.h"

#import "NSString+EXPDateTransform.h"

static NSInteger kGapBetweenView = 10;

@interface EXPDetailBaseInfoView()

@property (nonatomic, strong) EXPMKPointBaseInfo *annotation;

@property (nonatomic, strong) EXPCustomLabelView *locationView;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) EXPCustomLabelView *expInfoView;
@property (nonatomic, strong) EXPCustomLabelView *commentLabelView;

@end

@implementation EXPDetailBaseInfoView

- (id)initWithAnnotation:(EXPMKPointBaseInfo *)annotation
{
    self = [super init];
    if (self) {
        _annotation = annotation;
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    NSInteger expInfoNum  = [self.annotation.hospitalNews.evidences count];
    NSString *expInfoString = expInfoNum > 0 ? [NSString stringWithFormat:@"%@条曝光", @(expInfoNum)] : @"暂无曝光信息";
    self.expInfoView = [[EXPCustomLabelView alloc] initWithImage:[UIImage imageNamed:@"icon_news"] andText:expInfoString];
    [self addSubview:self.expInfoView];
    
    NSMutableString *address = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.annotation.address]];
    if (self.annotation.city.length > 0) {
        [address insertString:[NSString stringWithFormat:@"%@ | ", self.annotation.city] atIndex:0];
    }
    self.locationView = [[EXPCustomLabelView alloc] initWithImage:[UIImage imageNamed:@"icon_map"] andText:[address copy]];
    self.locationView.numberofLine = 0;
    [self addSubview:self.locationView];
    
    if (self.annotation.province.length > 0) {
        [address insertString:[NSString stringWithFormat:@"%@ | ", self.annotation.province] atIndex:0];
    }
   
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.text = [self.annotation.phones componentsJoinedByString:@","];
    [self addSubview:self.phoneLabel];
    
    self.updateTimeLabel = [[UILabel alloc] init];
    NSString *timeString = [NSString stringFromDate:self.annotation.updateTime] ?: @"2016-8-30";
    self.updateTimeLabel.text = [NSString stringWithFormat:@"最后更新时间: %@", timeString];
    [self addSubview:self.updateTimeLabel];
    
    NSInteger commentNum  = [self.annotation.comments.evidences count];
    NSString *commentString = commentNum > 0 ? [NSString stringWithFormat:@"%@条评论", @(commentNum)] : @"暂无评论";
    self.commentLabelView = [[EXPCustomLabelView alloc] initWithImage:[UIImage imageNamed:@"icon_comment"] andText:commentString];
    [self addSubview:self.commentLabelView];
}

- (void)updateConstraints
{
    [self.expInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(kGapBetweenView);
        make.height.equalTo(@16);
        make.right.lessThanOrEqualTo(self.updateTimeLabel.mas_left).offset(-2);
    }];
    
    [self.commentLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expInfoView.mas_left);
        make.top.equalTo(self.expInfoView.mas_bottom).offset(kGapBetweenView / 2);
        make.height.equalTo(@16);
        make.right.lessThanOrEqualTo(self.updateTimeLabel.mas_left).offset(-2);
    }];
    
    [self.updateTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.expInfoView.mas_bottom);
        make.height.equalTo(@16);
    }];
    
    [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expInfoView.mas_left);
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.commentLabelView.mas_bottom).offset(kGapBetweenView);
    }];
    
    [self.phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expInfoView.mas_left);
        make.right.equalTo(self.mas_right).offset(-12);
        if (self.phoneLabel.text.length > 0) {
            make.height.equalTo(@16);
            make.top.equalTo(self.locationView.mas_bottom).offset(kGapBetweenView);
        } else {
            make.height.equalTo(@0);
            make.top.equalTo(self.locationView.mas_bottom);
        }
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [super updateConstraints];
}


@end
