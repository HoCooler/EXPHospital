//
//  EXPListViewController.h
//  ExposeHospital
//
//  Created by HoCooler on 16/7/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EXPMKPointAnnotation;

@interface EXPListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>

- (instancetype)initWithHospitals:(NSArray <EXPMKPointAnnotation *> *)hospitals;

@end
