//
//  EXPClusterAnnotationView.h
//  ExposeHospital
//
//  Created by HoCooler on 16/5/16.
//  Copyright © 2016年 HoCooler. All rights reserved.
//


@interface EXPClusterAnnotationView : MKAnnotationView

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, getter = isUniqueLocation) BOOL uniqueLocation;

@end
