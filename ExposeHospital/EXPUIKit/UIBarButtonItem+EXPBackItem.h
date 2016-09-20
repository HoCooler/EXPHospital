//
//  UIBarButtonItem+EXPBackItem.h
//  ExposeHospital
//
//  Created by HoCooler on 16/8/21.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (EXPBackItem)

+ (UIBarButtonItem *)exp_leftBarButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

@end
