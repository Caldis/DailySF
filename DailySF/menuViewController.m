//
//  menuViewControllerTableViewController.m
//  DailySF
//
//  Created by 陈标 on 6/22/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "menuViewController.h"
#import "mainViewController.h"

static NSString * const kICSColorsViewControllerCellReuseId = @"kICSColorsViewControllerCellReuseId";

@interface menuViewController ()

@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, assign) NSInteger previousRow;

@end

@implementation menuViewController

//初始化为色彩
- (id)initWithColors:(NSArray *)colors{
    NSParameterAssert(colors);
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.colors = colors;
    }
    return self;
}
//初始化为菜单
- (id)initWithMenus:(NSArray *)menuList andColors:(NSArray *)colors{
    NSParameterAssert(menuList);
    NSParameterAssert(colors);

    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.menuList = menuList;
        self.colors = colors;
    }
    return self;
}

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kICSColorsViewControllerCellReuseId];
    //设置为无分割线
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//设定状态栏
#pragma mark - Configuring the view’s layout behavior
//设定状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 就算这个LeftViewCntroller隐藏了状态栏，要实现这个方法让然需要匹配相应的CenterViewController中相应的方法
    // 当状态栏被右滑打开时，避免状态栏的类型为flickr
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleLightContent;
}
//状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//设定TableView
#pragma mark - Table view data source
//多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//每个Sections多少行（Cell）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(self.menuList);
    return self.menuList.count;
}
//设定每行（Cell）的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.menuList);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICSColorsViewControllerCellReuseId forIndexPath:indexPath];
    cell.textLabel.text = [self.menuList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = self.colors[indexPath.row];
    
    return cell;
}

//设定相应的TableView点击后的动作
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.previousRow) {
        // Close the drawer without no further actions on the center view controller
        // 关闭drawer而不用CenterViewController实施进一步的工作
        [self.drawer close];
    }
    else {
        switch (indexPath.row) {
            case 0:{
                //Replace the current center view controller with a new one
                //替换当前的CenterViewController为Storybroad中的mainCenterViewController
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                mainViewController *center = (mainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainCenterViewController"];
                [self.drawer replaceCenterViewControllerWithViewController:center];
                break;
            }
            case 1:{
                //Replace the current center view controller with a new one
                //替换当前的CenterViewController为Storybroad中的optionCenterViewController
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                mainViewController *center = (mainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"optionCenterViewController"];
                [self.drawer replaceCenterViewControllerWithViewController:center];
                break;
            }
            case 2:{
                //Replace the current center view controller with a new one
                //替换当前的CenterViewController为Storybroad中的aboutCenterViewController
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                mainViewController *center = (mainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"aboutCenterViewController"];
                [self.drawer replaceCenterViewControllerWithViewController:center];
                break;
            }
            default:
                break;
        }
    }
    self.previousRow = indexPath.row;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen: (ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}
- (void)drawerControllerDidOpen:  (ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}
- (void)drawerControllerDidClose: (ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}

@end
