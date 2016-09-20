//
//  EXPCustomLabelView.h
//  ExposeHospital
//
//  Created by HoCooler on 16/8/28.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPCustomLabelView : UIView

- (instancetype)initWithImage:(UIImage *)image andText:(NSString *)text;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger numberofLine;

@end
