//
//  SweepingProgressBar.h
//  SweepingProgressBar
//
//  Created by Brian Fioca on 1/27/13.
//  Copyright (c) 2013 Brian Fioca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SweepingProgressBar : UIView

@property (strong) UIColor *bgColor;
@property (strong) UIColor *indicatorColor;
@property (strong) UIColor *borderColor;

+ (void)showInView:(UIView *)view;
+ (void)dismiss;

@end
