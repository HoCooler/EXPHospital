//
//  EXPCustomLabelView.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/28.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPCustomLabelView.h"

@interface EXPCustomLabelView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation EXPCustomLabelView

- (instancetype)initWithImage:(UIImage *)image andText:(NSString *)text
{
    self = [super init];
    if (self) {
        _text = text;
        _image = image;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.label = [[UILabel alloc] init];
    self.label.font = Font(16);
    self.label.text = self.text;
    [self addSubview:self.label];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self addSubview:self.imageView];
}

- (void)updateConstraints
{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        if (self.image) {
            make.width.height.equalTo(@(16));
        } else {
            make.width.height.equalTo(@(0));
        }
        make.centerY.equalTo(self.label.mas_centerY);
    }];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.image) {
            make.left.equalTo(self.imageView.mas_right).offset(8);
        } else {
            make.left.equalTo(self.imageView.mas_right);
        }
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(1);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
    
    [super updateConstraints];
}

- (void)setText:(NSString *)text
{
    if (![self.text isEqualToString:text]) {
        self.text = text;
        self.label.text = text;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setImage:(UIImage *)image
{
    if (![self.image isEqual:image]) {
        self.image = image;
        self.imageView.image = image;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setNumberofLine:(NSInteger)numberofLine
{
    self.label.numberOfLines = numberofLine;
    [self setNeedsUpdateConstraints];
}
@end
