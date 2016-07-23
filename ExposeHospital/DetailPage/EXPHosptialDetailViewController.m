//
//  EXPHosptialDetailViewController.m
//  ExposeHospital
//
//  Created by HoCooler on 16/7/23.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPHosptialDetailViewController.h"
#import "EXPMKPointAnnotation.h"

@interface EXPHosptialDetailViewController()

@property (nonatomic, strong) EXPMKPointAnnotation *annotation;
@end

@implementation EXPHosptialDetailViewController

- (id)initWithAnnotation:(EXPMKPointAnnotation *)annotation
{
    self = [super init];
    if (self) {
        _annotation = annotation;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
