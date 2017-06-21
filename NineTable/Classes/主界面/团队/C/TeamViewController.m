//
//  TeamViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TeamViewController.h"
#import "MyTeamViewController.h"
#import "ManagerTeamController.h"
#import "AddMoreView.h"
#import "CreateCateViewController.h"
#import "CreateMobanController.h"
#import "RootNavgationController.h"


@interface TeamViewController ()<UIScrollViewDelegate>

/** seg */
@property (strong,nonatomic) UISegmentedControl *segmentView;
/** 标签数组 */
@property (copy,nonatomic) NSArray *titleArr;
/** 内容视图 */
@property (strong,nonatomic) UIScrollView *contentView;

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeamMoreAction)];
    
    [self setupSubViews];
    
}
- (void)addTeamMoreAction
{
    // 创建分类、创建模板
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    AddMoreView *moreView = [[AddMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.DidSelectBlock = ^(ClickIndex index) {
        if (index == CreateClassIndex) {
            CreateCateViewController *cate = [[CreateCateViewController alloc]init];
            cate.ReloadBlock = ^{
                // 通知团队模板界面刷新界面
                ManagerTeamController *teamMobanVC = (ManagerTeamController *)[self.childViewControllers firstObject];
                [teamMobanVC refreshTableAction];
            };
            RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:cate];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }else if (index == CreateMobanIndex){
            CreateMobanController *cate = [[CreateMobanController alloc]init];
            RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:cate];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
    };
    [keyWindow addSubview:moreView];
}
#pragma mark - 创建界面
- (void)setupSubViews
{
    self.titleArr = @[@"团队模板",@"我的团队"];
    // segment
    __weak TeamViewController *copySelf = self;
    self.segmentView = [[UISegmentedControl alloc]initWithItems:self.titleArr];
    self.segmentView.frame = CGRectMake(0, 0, 138, 30);
    
    [self.segmentView addBlockForControlEvents:UIControlEventValueChanged block:^(UISegmentedControl *sender) {
        // 标签点击方法
        NSInteger index = sender.selectedSegmentIndex;
        copySelf.segmentView.selectedSegmentIndex = sender.selectedSegmentIndex;
        
        CGFloat offsetX = index * copySelf.contentView.width;
        CGFloat offsetY = copySelf.contentView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [copySelf.contentView setContentOffset:offset animated:YES];
        
    }];
    self.segmentView.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentView;
    
    // 初始化内容滚动栏
    [self setupContentScrollView];
    // 添加子控制器
    [self addController];
    // 设置默认控制器
    [self addDefaultController];
}

- (void)setupContentScrollView
{
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.bounces = NO;
    contentScrollView.y = 0;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.width = self.view.width;
    
    // 判断是否是点击tabbar中间加号进来的，如果是则不减去tabbar的高度
    CGFloat scrollViewH;
    scrollViewH = self.view.height - 44;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArr.count, 0);
    contentScrollView.pagingEnabled = YES;
    self.contentView = contentScrollView;
    [self.view insertSubview:self.contentView belowSubview:self.segmentView];
    
}

- (void)addController
{
    
    ManagerTeamController *vc1 = [ManagerTeamController new];
    [self addChildViewController:vc1];
    
    MyTeamViewController *vc2 = [MyTeamViewController new];
    [self addChildViewController:vc2];
    
}
- (void)addDefaultController
{
    UIViewController *defaultVC = [self.childViewControllers firstObject];
    defaultVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:defaultVC.view];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentView.frame.size.width;
    self.segmentView.selectedSegmentIndex = index;
    if (index == 0) {
        ManagerTeamController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }else {
        MyTeamViewController *newVc = self.childViewControllers[index];
        if (newVc.view.superview) return;
        newVc.view.frame = scrollView.bounds;
        [self.contentView addSubview:newVc.view];
    }
}

// 滚动结束（手势导致）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}



@end
