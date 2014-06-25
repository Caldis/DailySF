//
//  ViewController.m
//  DailySF
//
//  Created by 陈标 on 6/21/14.
//  Copyright (c) 2014 Cb. All rights reserved.
//

#import "mainViewController.h"

NSString *const MJTableViewCellIdentifier = @"Cell";

@interface mainViewController ()
//PARA
@property (strong,nonatomic) NSArray *tableItems;
//ICSD
@property(nonatomic, strong) UIButton *openDrawerButton;
@end

@implementation mainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
	// Do any additional setup after loading the view, typically from a nib.
    self.tableItems = @[[UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_4.png"],
                        [UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_4.png"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_4.png"]];
    
    
    
    //初始化并且添加openDrawerButton
    UIImage *hamburger = [UIImage imageNamed:@"menubuttom"];
     self.openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
     self.openDrawerButton.frame = CGRectMake(10.0f, 28.0f, 44.0f, 44.0f);
    [self.openDrawerButton setImage:hamburger forState:UIControlStateNormal];
    [self.openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openDrawerButton];
    
    // 1.注册cell
    [self.tableViewReflush registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    // 2.集成刷新控件
    [self setupRefresh];}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma maek - Table view data source
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每个section多少行（cell）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableItems.count;
}
//返回UITableViewCell的实例（必须）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"parallaxCell";
    JBParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Cell %d",), indexPath.row];
    cell.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This is a parallex cell %d",),indexPath.row];
    cell.parallaxImage.image = self.tableItems[indexPath.row];
        
    return cell;
}

//ICSD
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableViewReflush visibleCells];
    
    for (JBParallaxCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableViewReflush didScrollOnView:self.view];
    }
}


#pragma mark - Configuring the view’s layout behavior
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting
//是否响应用户操作
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}
- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button
//点击菜单按钮的操作
- (void)openDrawer:(id)sender{
    [self.drawer open];
}


#pragma mark - Start to refresh
//下拉刷新
- (void)headerRefreshing{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        //[self.fakeData insertObject:MJRandomData atIndex:0];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableViewReflush reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableViewReflush headerEndRefreshing];
    });
}
//上拉刷新
- (void)footerRefreshing{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        //[self.fakeData addObject:MJRandomData];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableViewReflush reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableViewReflush footerEndRefreshing];
    });
}
//初始化刷新
- (void)setupRefresh{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableViewReflush addHeaderWithTarget:self action:@selector(headerRefreshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.tableViewReflush headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableViewReflush addFooterWithTarget:self action:@selector(footerRefreshing)];
}

@end