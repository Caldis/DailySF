//
//  storyViewController.m
//  DailySF
//
//  Created by 陈标 on 6/25/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "storyViewController.h"

@implementation storyViewController
int viewDidLoad = 0;
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //页面标示符
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.viewPage = (NSInteger *)1;
    
    //初始化并且添加backButton
    UIImage *hamburger = [UIImage imageNamed:@"backbuttom"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10.0f, 22.0f, 35.0f, 35.0f);
    [self.backButton setImage:hamburger forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    viewDidLoad = 1;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (viewDidLoad)
        return YES;
    else
        return NO;
}

- (void)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.viewPage = (NSInteger *)0;
    viewDidLoad = 0;
}

@end
