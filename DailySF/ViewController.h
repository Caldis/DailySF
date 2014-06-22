//
//  ViewController.h
//  DailySF
//
//  Created by 陈标 on 6/21/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBParallaxCell.h"
#import "ICSDrawerController.h"
#import "menuViewController.h"

@interface ViewController : UIViewController <UIScrollViewDelegate,ICSDrawerControllerChild, ICSDrawerControllerPresenting>
//PARA
@property (weak,nonatomic) IBOutlet UITableView *tableView;
//ICSD
@property(nonatomic, weak) ICSDrawerController *drawer;
@end
