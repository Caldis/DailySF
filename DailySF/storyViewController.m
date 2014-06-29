//
//  storyViewController.m
//  DailySF
//
//  Created by 陈标 on 6/25/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "storyViewController.h"

@implementation storyViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化并且添加openDrawerButton
    UIImage *hamburger = [UIImage imageNamed:@"backbuttom"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10.0f, 22.0f, 35.0f, 35.0f);
    [self.backButton setImage:hamburger forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

- (void)back:(id)sender{
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
