//
//  storyViewController.h
//  DailySF
//
//  Created by 陈标 on 6/25/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface storyViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *storyTitleLabel;
@property (nonatomic, assign) NSString *storyTitle;

@property (nonatomic, strong) IBOutlet UIWebView *storyWebView;
@property (nonatomic, strong) NSData *storyContent;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;



@end
