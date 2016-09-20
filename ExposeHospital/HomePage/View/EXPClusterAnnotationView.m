//
//  EXPClusterAnnotationView.m
//  ExposeHospital
//
//  Created by HoCooler on 16/5/16.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#import "EXPClusterAnnotationView.h"

@interface EXPClusterAnnotationView()

@property (nonatomic, strong) UILabel *countLabel;

@end
@implementation EXPClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self setUpLabel];
		[self setCount:1];
	}
	return self;
}

- (void)setUpLabel
{
	_countLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_countLabel.textAlignment = NSTextAlignmentCenter;
	_countLabel.backgroundColor = [UIColor clearColor];
	_countLabel.textColor = [UIColor whiteColor];
	_countLabel.textAlignment = NSTextAlignmentCenter;
	_countLabel.adjustsFontSizeToFitWidth = YES;
	_countLabel.minimumScaleFactor = 2;
	_countLabel.numberOfLines = 1;
	_countLabel.font = [UIFont boldSystemFontOfSize:12];
	_countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	
	[self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count
{
	_count = count;
	self.countLabel.text = [@(count) stringValue];
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	UIImage *image;
	CGPoint centerOffset;
	CGRect countLabelFrame;
	if (self.isUniqueLocation) {
		NSString *imageName = @"SquareBlue";
		image = [UIImage imageNamed:imageName];
		centerOffset = CGPointMake(0, image.size.height * 0.5);
		CGRect frame = self.bounds;
		frame.origin.y -= 2;
		countLabelFrame = frame;
	} else {
		NSString *suffix;
		if (self.count > 1000) {
			suffix = @"39";
		} else if (self.count > 200) {
			suffix = @"38";
		} else if (self.count > 100) {
			suffix = @"36";
		} else if (self.count > 50) {
			suffix = @"34";
		} else if (self.count > 20) {
			suffix = @"31";
		} else if (self.count > 9) {
			suffix = @"28";
		} else if (self.count > 3) {
			suffix = @"25";
		} else if (self.count > 1) {
			suffix = @"24";
		} else {
			suffix = @"21";
		}
		
		NSString *imageName = [NSString stringWithFormat:@"%@%@", @"CircleRed", suffix];
		image = [UIImage imageNamed:imageName];
		
		centerOffset = CGPointZero;
		countLabelFrame = self.bounds;
	}
	
	self.countLabel.frame = countLabelFrame;
	self.image = image;
	self.centerOffset = centerOffset;

}
@end
