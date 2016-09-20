//
//  EXPDetailNewsCell.h
//  ExposeHospital
//
//  Created by HoCooler on 16/8/28.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const EXPDetailCellHeight;

@class EXPEvidenceInfo;

@interface EXPDetailNewsCell : UITableViewCell

@property (nonatomic, strong) EXPEvidenceInfo *info;

@end
