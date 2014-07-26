//
//  storyViewController.m
//  DailySF
//
//  Created by 陈标 on 6/25/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "storyViewController.h"

@implementation storyViewController

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //页面标示符
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.inMainViewController = (NSInteger *)0;
    NSLog(@"Now inMainViewController is 0");
    
    //初始化并且添加backButton
    UIImage *hamburger = [UIImage imageNamed:@"backButtom"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10.0f, 24.0f, 33.0f, 33.0f);
    [self.backButton setImage:hamburger forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //接管手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    //设置标题
    self.storyTitleLabel.text = self.storyTitle;
    //设置内容
    [self.storyWebView loadData:self.storyContent MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
}

//在本页面时候接管右滑菜单，改为右滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


//返回按钮的操作
- (void)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.inMainViewController = (NSInteger *)1;
    NSLog(@"Now inMainViewController is 1");

}

@end
