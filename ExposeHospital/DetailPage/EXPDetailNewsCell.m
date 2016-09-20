//
//  EXPDetailNewsCell.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/28.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPDetailNewsCell.h"
#import "EXPEvidenceInfo.h"

NSInteger const EXPDetailCellHeight = 80;

@interface EXPDetailNewsCell()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *newsImage;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *sourceLabel;

@end

@implementation EXPDetailNewsCell

- (void)setInfo:(EXPEvidenceInfo *)info
{
    if (![_info isEqual:info]) {
        _info = info;
        @weakify(self)
        if ([info.snapShotString length] > 0) {
            [self.newsImage sd_setImageWithURL:[NSURL URLWithString:info.snapShotString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                @strongify(self)
                if (!image || error) {
                    self.newsImage.image = [UIImage imageNamed:@"icon_news"];
                }
            }];
        }
        self.titleLable.text = info.title;
        if ([info.sourceURLString length] > 0) {
            self.sourceLabel.text = [NSString stringWithFormat:@"来源: %@", info.sourceURLString];
        }
        [self setNeedsUpdateConstraints];
    }
}

- (void)searchMore
{
    
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = Font(18);
        _titleLable.numberOfLines = 0;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitle:@"搜索更多" forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(searchMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
    }
    return _moreButton;
}

- (UILabel *)sourceLabel
{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = Font(12);
        _sourceLabel.textColor = [UIColor grayColor];
        [self addSubview:_sourceLabel];
    }
    return _sourceLabel;
}

- (UIImageView *)newsImage
{
    if (!_newsImage) {
        _newsImage = [[UIImageView alloc] init];
        [self addSubview:_newsImage];
    }
    return _newsImage;
}

- (void)updateConstraints
{
    [self.newsImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.titleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.newsImage.mas_top);
        make.bottom.lessThanOrEqualTo(self.sourceLabel.mas_top);
        make.right.equalTo(self.newsImage.mas_left).offset(-10);
    }];
    
    [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.newsImage.mas_bottom);
        make.left.equalTo(self.titleLable.mas_left);
        make.right.lessThanOrEqualTo(self.newsImage.mas_left);
        make.height.equalTo(@15);
    }];
    
    [super updateConstraints];
}
@end
