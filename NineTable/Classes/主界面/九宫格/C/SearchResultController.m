//
//  SearchResultController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchResultController.h"
#import <MJRefresh/MJRefresh.h>
#import "NineTableCollectionCell.h"
#import "MobanDetialController.h"

#define Space 6
@interface SearchResultController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
{
    int CurrentPage; // 当前页码、默认为1
}

/** UICollectionView */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

/** 搜索框 */
@property (strong,nonatomic) UISearchBar *searchBar;

@end

@implementation SearchResultController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"模板关键字";
    [self.view addSubview:self.searchBar];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect frame;
    frame = CGRectMake(0, self.searchBar.height, SCREEN_WIDTH, self.view.height - 64 - self.searchBar.height);
    self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerClass:[NineTableCollectionCell class] forCellWithReuseIdentifier:@"NineTableCollectionCell"];
    [self.view addSubview:self.collectionView];
    
    
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];

    
    [[NineTableManager sharedManager].netManager searchMobanWithKeyWord:searchBar.text Success:^(NSArray *array) {
        [self.collectionView.mj_header endRefreshing];
        [self hideMessageAction];
        self.array = array;
        [self.collectionView reloadData];
    } Fail:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
        [self showEmptyViewWithMessage:errorMsg];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MobanInfoModel *model = self.array[indexPath.row];
    NineTableCollectionCell *cell = [NineTableCollectionCell sharedCell:collectionView Path:indexPath];
    cell.mobanModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MobanInfoModel *model = self.array[indexPath.row];
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


@end
