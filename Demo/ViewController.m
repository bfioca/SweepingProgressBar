//
//  ViewController.m
//  SweepingProgressBar
//
//  Created by Brian Fioca on 1/27/13.
//  Copyright (c) 2013 Brian Fioca. All rights reserved.
//

#import "ViewController.h"
#import "SweepingProgressBar.h"

@interface ViewController ()

@end

@implementation ViewController {
    BOOL _running;
}

@synthesize startBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _running = NO;
}

- (IBAction)startProgressBar:(id)sender
{
    if (!_running) {
        [SweepingProgressBar showInView:self.view];
        [startBtn setTitle:@"Stop trying to make it happen." forState:UIControlStateNormal];
        _running = YES;
    } else {
        [SweepingProgressBar dismiss];
        [startBtn setTitle:@"Make Progress Bar Happen" forState:UIControlStateNormal];
        _running = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
