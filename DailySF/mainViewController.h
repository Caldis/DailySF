//
//  MJViewController.h
//  ParallaxImages
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"
#import "ICSDrawerController.h"
#import "menuViewController.h"
#import "storyViewController.h"
#import "MJRefresh.h"

@interface mainViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>
//ICSD
@property(nonatomic, weak) ICSDrawerController *drawer;

@end
