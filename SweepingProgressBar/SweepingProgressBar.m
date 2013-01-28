//
//  SweepingProgressBar.m
//  SweepingProgressBar
//
//  Created by Brian Fioca on 1/27/13.
//  Copyright (c) 2013 Brian Fioca. All rights reserved.
//

#import "SweepingProgressBar.h"

#import <QuartzCore/QuartzCore.h>


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SweepingProgressBar (private)
-(void) setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
-(void) deviceOrientationDidChange:(NSNotification *)notification;
@end

@implementation SweepingProgressBar {
    UIView *_view;
    UIView *_spinnerView;
}

static float kProgressBarWidth = 75.0;
static float kProgressBarHeight = 8.0;
static float kSpinnerWidth = 8.0;
static float kSpinnerHeight = 8.0;
static int kSpinnerTag = 10;

@synthesize bgColor = _bgColor;
@synthesize indicatorColor = _indicatorColor;
@synthesize borderColor = _borderColor;

+ (SweepingProgressBar*)sharedView
{
    static dispatch_once_t once;
    static SweepingProgressBar *sharedView;
    float x = ([[UIScreen mainScreen] bounds].size.width - kProgressBarWidth) / 2;
    float y = [[UIScreen mainScreen] bounds].origin.y;
    CGRect endRect = CGRectMake(x, y - kProgressBarHeight, kProgressBarWidth, 0);
    dispatch_once(&once, ^ { sharedView = [[SweepingProgressBar alloc] initWithFrame:endRect]; });
    return sharedView;
}

// Show the default progress bar with standard colors
+ (void) showInView:(UIView *)view
{
    return [[SweepingProgressBar sharedView] showInView:view
                                        backgroundColor:UIColorFromRGB(0x363431)
                                         indicatorColor:UIColorFromRGB(0xff5500)
                                            borderColor:UIColorFromRGB(0x7c7476)];    
}

+ (void) showInView:(UIView *)view backgroundColor: cbgColor indicatorColor: cindicatorColor borderColor: cborderColor
{
    return [[SweepingProgressBar sharedView] showInView:view
                                    backgroundColor:cbgColor
                                     indicatorColor:cindicatorColor
                                        borderColor:cborderColor];
}

+ (void) dismiss
{
    [[SweepingProgressBar sharedView] dismiss];
}


- (void) showInView:(UIView *)view
    backgroundColor:(UIColor *) bgColor
     indicatorColor:(UIColor *) indicatorColor
        borderColor:(UIColor *) borderColor
{
    _view = view;
    self.bgColor = bgColor;
    self.indicatorColor = indicatorColor;
    self.borderColor = borderColor;
    // Centers it in the current view's frame.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kill)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [_view addSubview:self];
        
        [self appear];
        
        [self setNeedsDisplay];
    });
}

- (void) dismiss
{
    _spinnerView.alpha = 0.0;
    
    CGRect endRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, kProgressBarWidth, 0);
    CGRect spinEndRect = CGRectMake(_spinnerView.frame.origin.x, _spinnerView.frame.origin.y, kSpinnerWidth, 0);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [_spinnerView setFrame:spinEndRect];
                         [self setFrame:endRect];
                     }
                     completion:^(BOOL completed) {
                         if(completed) {
                             [self kill];
                         }
                     }];
}

- (void)kill
{
    [self removeFromSuperview];
    [_spinnerView removeFromSuperview];
    _spinnerView = nil;
}

#pragma mark - UIViewOverloads

- (void) removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [super removeFromSuperview];
}

- (void) appear
{
    if (_spinnerView != nil)
        return;
    
    _spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kSpinnerWidth, kSpinnerHeight)];
    
    [self setRoundedView:_spinnerView toDiameter:kSpinnerHeight];
    [_spinnerView setBackgroundColor:self.indicatorColor];
    [self addSubview:_spinnerView];
    _spinnerView.tag = kSpinnerTag;
    [_spinnerView setAlpha:0.0];
    
    // Layout the holder
    float x = (self.superview.bounds.size.width - kProgressBarWidth) / 2;
    float y = self.superview.bounds.origin.y;
    CGRect endRect = CGRectMake(x, y - kProgressBarHeight, kProgressBarWidth, 0);
    [self setFrame:endRect];
    [self.layer setCornerRadius:4.0];
    [self.layer setBorderColor:[self.borderColor CGColor]];
    [self.layer setBorderWidth:0.5];
    [self setBackgroundColor:self.bgColor];
    [self setAlpha:0.0];
    [_spinnerView setAlpha:0.0];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.alpha = 1.0;
                         [_spinnerView setAlpha:0.0];
                         CGRect endRect = CGRectMake(x, y - (kProgressBarHeight / 2), kProgressBarWidth, kProgressBarHeight);
                         [self setFrame:endRect];
                     }
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.2f
                                               delay:0.0f
                                             options: UIViewAnimationCurveEaseOut
                                          animations: ^(void){
                                              _spinnerView.alpha = 1.0;
                                          }
                                          completion:nil];
                         
                         [self setBackgroundColor:self.bgColor];
                         if(completed) {
                             [UIView animateWithDuration:1.0f
                                                   delay:0.0f
                                                 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseIn
                                              animations: ^(void){
                                                  float x = kProgressBarWidth - kSpinnerWidth;
                                                  _spinnerView.frame = CGRectMake(x, _spinnerView.frame.origin.y, kSpinnerWidth, kSpinnerHeight);
                                              }
                                              completion:nil];
                         }
                     }];
}


#pragma mark - Helpers

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void) deviceOrientationDidChange:(NSNotification *)notification
{
	if (!self.superview) {
		return;
	}
    self.bounds = self.superview.bounds;
    [self setNeedsLayout];
}

@end
