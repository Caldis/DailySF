//
//  storyViewController.h
//  DailySF
//
//  Created by 陈标 on 6/25/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ICSDrawerController.h"
#import "mainViewController.h"

@interface storyViewController : UIViewController <ICSDrawerControllerPresenting>

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) NSArray *DetailModal;
@property (strong, nonatomic) UIButton *backButton;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end
