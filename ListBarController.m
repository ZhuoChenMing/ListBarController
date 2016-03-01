//
//  ListBarController.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ListBarController.h"
#import "ListBarScrollView.h"
#import "ArrowButton.h"
#import "DetailListScrollView.h"
#import "DeleteBarView.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ListBarController () <UIScrollViewDelegate, ListBarScrollViewDelegate>

@property (nonatomic,strong) ListBarScrollView *listBar;

@property (nonatomic,strong) DeleteBarView *deleteBar;

@property (nonatomic,strong) DetailListScrollView *detailsList;

@property (nonatomic,strong) ArrowButton *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@end

@implementation ListBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self makeContent];
}

- (void)makeContent {
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"推荐",@"热点",@"杭州",@"社会",@"娱乐",@"科技",@"汽车",@"体育",@"订阅",@"财经",@"军事",@"国际",@"正能量",@"段子",@"趣图",@"美女",@"健康",@"教育",@"特卖",@"彩票",@"辟谣"]];
    NSMutableArray *listBottom = [[NSMutableArray alloc] initWithArray:@[@"电影",@"数码",@"时尚",@"奇葩",@"游戏",@"旅游",@"育儿",@"减肥",@"养生",@"美食",@"政务",@"历史",@"探索",@"故事",@"美文",@"情感",@"语录",@"美图",@"房产",@"家居",@"搞笑",@"星座",@"文化",@"毕业生",@"视频"]];
    
    __weak typeof(self) unself = self;
    if (!self.detailsList) {
        self.detailsList = [[DetailListScrollView alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAllAray = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    if (!self.listBar) {
        self.listBar = [[ListBarScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.barDelegate = self;
        self.listBar.arrowChange = ^(){
            if (unself.arrow.arrowBtnClick) {
                unself.arrow.arrowBtnClick();
            }
        };
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[DeleteBarView alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    if (!self.arrow) {
        self.arrow = [[ArrowButton alloc] initWithFrame:CGRectMake(kScreenW - kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y < 0) ? CGAffineTransformMakeTranslation(0, kScreenH) : CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW, kScreenH-kListBarH - 64)];
        self.mainScroller.backgroundColor = [UIColor yellowColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW * 10,self.mainScroller.frame.size.height);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
#warning 预加载、清除防止内存过大等操作暂时不做了~~
        [self addScrollViewWithItemName:@"推荐" index:0];
        [self addScrollViewWithItemName:@"测试" index:1];
    }
}

- (void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index {
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(index * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height)];
    scroller.backgroundColor = RGBColor(arc4random() % 255, arc4random() % 255, arc4random() % 255);
    [self.mainScroller addSubview:scroller];
}

#pragma mark - ListBarScrollView代理
- (void)selectListBarButtonAtIndex:(NSInteger)index itemName:(NSString *)itemName {
    [self.detailsList itemRespondFromListBarClickWithItemName:itemName];
    //添加scrollview
    
    //移动到该位置
    self.mainScroller.contentOffset =  CGPointMake(index * self.mainScroller.frame.size.width, 0);
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
}

@end
