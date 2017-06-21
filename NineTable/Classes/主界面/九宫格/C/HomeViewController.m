//
//  HomeViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "HomeViewController.h"
#import "NineTopViewReusableView.h"
#import "NineTableCollectionCell.h"
#import "MobanDetialController.h"
#import <SDCycleScrollView.h>
#import "SearchFieldView.h"
#import "CateMobanController.h"
#import "MessageViewController.h"
#import "SearchResultController.h"
#import "AllCateListViewController.h"
#import <MJRefresh.h>
#import "NavigationView.h"


#define TopViewH (180*CKproportion + (SCREEN_HEIGHT - 44) * 0.3)
#define Space 6

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,NineTopViewDelegate>

/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 首页数据模型 */
@property (strong,nonatomic) HomeDataModel *homeModel;

/** 头部 */
@property (strong,nonatomic) NineTopViewReusableView *headerView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格";
    [self setupSubViews];
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 表格
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 44) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerClass:[NineTableCollectionCell class] forCellWithReuseIdentifier:@"NineTableCollectionCell"];
    [self.collectionView registerClass:[NineTopViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineTopViewReusableView"];
    [self.view addSubview:self.collectionView];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取首页数据
        [self refreshCollectionAction];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    // 左右侧
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(messageClickAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMobanAction)];
    
}
// 刷新数据
- (void)refreshCollectionAction
{
    // 获取首页的全部数据
    [[NineTableManager sharedManager].netManager getHomeDataSuccess:^(HomeDataModel *homeModel) {
        
        [self.collectionView.mj_header endRefreshing];
        [self hideMessageAction];
        
        self.homeModel = homeModel;
        // 分类图标列表
        self.headerView.homeModel = self.homeModel;
        
        // 最新模板
        [self.collectionView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
        [self showEmptyViewWithMessage:errorMsg];
    }];
    
}
// 查看消息
- (void)messageClickAction
{
    MessageViewController *message = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:message animated:YES];
}
// 搜索模板
- (void)searchMobanAction
{
    SearchResultController *search = [[SearchResultController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeModel.template.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MobanInfoModel *model = self.homeModel.template[indexPath.row];
    NineTableCollectionCell *cell = [NineTableCollectionCell sharedCell:collectionView Path:indexPath];
    cell.mobanModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MobanInfoModel *model = self.homeModel.template[indexPath.row];
    MobanDetialController *detial = [[MobanDetialController alloc]initWithModel:model];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.width - 4*Space)/3;
    CGFloat height = width + 30;
    return CGSizeMake(width, height);
}
// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(Space, Space, Space, Space);
}

// 定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return Space;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return Space;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, TopViewH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NineTopViewReusableView" forIndexPath:indexPath];
        self.headerView.delegate = self;
        reusableview = self.headerView;
    }
    
    return reusableview;
}

#pragma mark - 点击分类代理
- (void)nineTopViewClickWithModel:(MobanClassModel *)classModel
{
    if (classModel.isAllMoBan) {
        AllCateListViewController *allCate = [[AllCateListViewController alloc]initWithModel:self.homeModel];
        allCate.ReloadCareListBlock = ^(HomeDataModel *homeModel) {
            self.homeModel = homeModel;
            self.headerView.homeModel = self.homeModel;
            [self.collectionView reloadData];
        };
        [self.navigationController pushViewController:allCate animated:YES];
    }else{
        // 查看分类详情
        CateMobanController *cateMoban = [[CateMobanController alloc]initWithModel:classModel];
        [self.navigationController pushViewController:cateMoban animated:YES];
    }
}

@end
