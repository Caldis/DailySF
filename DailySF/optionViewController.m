//
//  optionViewController.m
//  DailySF
//
//  Created by 陈标 on 6/22/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "optionViewController.h"

@implementation optionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.inMainViewController = (NSInteger *)1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
