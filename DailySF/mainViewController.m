//
//  MJViewController.m
//  ParallaxImages
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "mainViewController.h"
#import "MJCollectionViewCell.h"

@interface mainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

//parallaxCollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *storyNameList;
@property (nonatomic, strong) NSMutableArray *storyDsecribeList;
@property (nonatomic, strong) NSMutableArray *storyPicList;
@property (nonatomic, strong) NSMutableArray *storyContentList;

//ICSD
@property(nonatomic, strong) UIButton *openDrawerButton;

@end


@implementation mainViewController
#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.parallaxCollectionView.allowsSelection = YES;
    
    //页面标示符
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.inMainViewController = (NSInteger *)1;
    NSLog(@"Now inMainViewController is 1");
    
    //侧滑菜单栏
    //初始化并且添加openDrawerButton
    UIImage *hamburger = [UIImage imageNamed:@"menubuttom"];
    self.openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openDrawerButton.frame = CGRectMake(10.0f, 18.0f, 44.0f, 44.0f);
    [self.openDrawerButton setImage:hamburger forState:UIControlStateNormal];
    [self.openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openDrawerButton];
    
    //下拉刷新
    // 1.注册cell
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    // 2.集成刷新控件
    //[self setupRefresh];
    
    [self getQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storyNameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    //获得title并设置到每个cell
    NSString *storyName = [self.storyNameList objectAtIndex:indexPath.item];
    cell.title = storyName;
    
    //获得describe并设置到每个cell
    NSString *storyDescribe = [self.storyDsecribeList objectAtIndex:indexPath.item];
    cell.describe = storyDescribe;

    //获得image并设置到每个cell
    NSData *imageData = [self.storyPicList objectAtIndex:indexPath.item];
    cell.image = [UIImage imageWithData:imageData];
    
    //设置图像相对自身的cell之偏移
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToStory"]) {
        NSIndexPath *selectedPath = [[self.parallaxCollectionView indexPathsForSelectedItems]objectAtIndex:0];
        
        storyViewController *storyView = segue.destinationViewController;
        //设置标题
        NSString *storyName = [self.storyNameList objectAtIndex:selectedPath.row];
        storyView.storyTitle = storyName;
        //设置内容
        NSData *storyContent = [self.storyContentList objectAtIndex:selectedPath.row];
        storyView.storyContent = storyContent;
    }
}

#pragma mark - UIScrollViewdelegate methods
//滚动时计算image的偏移
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(MJCollectionViewCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置Cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - Configuring the view’s layout behavior
//设置状态栏
- (BOOL)prefersStatusBarHidden{
    return NO;
 }
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting
//开/关侧边菜单的时候是否响应用户操作
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
    self.openDrawerButton.userInteractionEnabled = YES;
}
- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
    self.openDrawerButton.userInteractionEnabled = NO;
}
- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
    self.openDrawerButton.userInteractionEnabled = NO;
}
- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
    self.openDrawerButton.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button
//点击菜单按钮的操作
- (void)openDrawer:(id)sender{
    [self.drawer open];
}

#pragma mark - AVOS
- (void)getQuery{
    AVQuery *query = [AVQuery queryWithClassName:@"StoryList"];
    //优先使用缓存
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    //每次获取的个数
    [query setLimit:10];
    //缓存时间（s）
    [query setMaxCacheAge:60*60];
    //过滤条件
    [query whereKeyExists:@"StoryName"];
    //排序依据
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count) {
            for (AVObject *post in objects) {
                AVObject *storyData = [query getObjectWithId:post.objectId];
                
                //获取文章标题
                NSString *storyName = [storyData objectForKey:@"StoryName"];
                if(!self.storyNameList) {
                    self.storyNameList = [NSMutableArray arrayWithCapacity:0];
                }
                [self.storyNameList addObject:storyName];
                
                //获取文章描述
                NSString *storyDescribe = [storyData objectForKey:@"StoryDescribe"];
                if(!self.storyDsecribeList) {
                    self.storyDsecribeList = [NSMutableArray arrayWithCapacity:0];
                }
                [self.storyDsecribeList addObject:storyDescribe];
                
                //获取文章配图
                AVFile *storyPic = [storyData objectForKey:@"StoryPic"];
                NSData *picData = [storyPic getData];
                if (!self.storyPicList) {
                    self.storyPicList = [NSMutableArray arrayWithCapacity:0];
                }
                [self.storyPicList addObject:picData];
                
                //获取文章内容
                AVFile *storyContent = [storyData objectForKey:@"StoryContent"];
                NSData *contentData = [storyContent getData];
                if (!self.storyContentList) {
                    self.storyContentList = [NSMutableArray arrayWithCapacity:0];
                }
                [self.storyContentList addObject:contentData];
            }
            [self reloadStoryData];
        }
        else {
            NSLog(@"ERROR ：%@",(NSString*)error);
        }
    }];
}

- (void) reloadStoryData{
    [self.parallaxCollectionView reloadData];
}

@end
