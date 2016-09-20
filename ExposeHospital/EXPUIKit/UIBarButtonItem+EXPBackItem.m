//
//  UIBarButtonItem+EXPBackItem.m
//  ExposeHospital
//
//  Created by HoCooler on 16/8/21.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "UIBarButtonItem+EXPBackItem.h"

@implementation UIBarButtonItem (EXPBackItem)

+ (UIBarButtonItem *)exp_leftBarButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 28, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(10, -6, 10, 10);
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
