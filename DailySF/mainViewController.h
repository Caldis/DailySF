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
#import "menuViewController.h"
#import "storyViewController.h"

#import "MJRefresh.h"
#import "ICSDrawerController.h"

@interface mainViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

//ICSD
@property(nonatomic, weak) ICSDrawerController *drawer;

//BGPic
@property(nonatomic, strong) IBOutlet UIImageView *colBG;

@end
