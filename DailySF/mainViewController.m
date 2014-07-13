//
//  MJViewController.m
//  ParallaxImages
//
//  Created by Mayur on 4/1/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "mainViewController.h"
#import "MJCollectionViewCell.h"

#define QUERY_LIMIT 10

@interface mainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

//parallaxCollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *storyNameList;
@property (nonatomic, strong) NSMutableArray *storyPicList;

//ICSD
@property(nonatomic, strong) UIButton *openDrawerButton;

@end


@implementation mainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //页面标示符
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.viewPage = (NSInteger *)0;
    
    // Fill image array with images
    NSUInteger index;
    for (index = 0; index < 14; ++index) {
        // Setup image name
        NSString *name = [NSString stringWithFormat:@"image%03ld.jpg", (unsigned long)index];
        if(!self.images)
            self.images = [NSMutableArray arrayWithCapacity:0];
        [self.images addObject:name];
        NSLog(@"imagesCount is : %lu",(unsigned long)self.images.count);
    }
    //[self.parallaxCollectionView reloadData];
    
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
    //return self.images.count;
    return self.storyNameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    //获得image并设置到cell
    NSString* imageName = [self.images objectAtIndex:indexPath.item];
    cell.image = [UIImage imageNamed:imageName];
    
    //设置图像相对cell偏移
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    //获得title并设置到cell
    NSString* storyName = [self.storyNameList objectAtIndex:indexPath.item];
    NSLog(@"cellStoryName %li is : %@ ",(long)indexPath.item,storyName);
    cell.title = storyName;

    return cell;
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
                NSLog(@"storyName is : %@",storyName);
                //NSMutableArray初始化长度
                if(!self.storyNameList)
                    self.storyNameList = [NSMutableArray arrayWithCapacity:0];
                [self.storyNameList addObject:storyName];
                NSLog(@"addObjectDone");
                //获取文章描述
                
                //获取文章配图
                
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
    NSLog(@"storyNameListNum : %lu",(unsigned long)self.storyNameList.count);
    NSLog(@"reloaddata");
}

@end
