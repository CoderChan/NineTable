//
//  CateMobanController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CateMobanController.h"
#import <MJRefresh/MJRefresh.h>
#import "NineTableCollectionCell.h"
#import "MobanDetialController.h"
#import "MobanInfoModel.h"
#import <MJExtension/MJExtension.h>
#import "HTTPManager.h"

#define Space 6

@interface CateMobanController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int CurrentPage; // 当前页码、默认为1
}
/** 模板分类 */
@property (strong,nonatomic) MobanClassModel *model;
/** coll */
@property (strong,nonatomic) UICollectionView *collectionView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation CateMobanController


- (instancetype)initWithModel:(MobanClassModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self setupSubViews];
}
#pragma mark - 表格相关
- (void)setupSubViews
{
    CurrentPage = 1;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect frame;
    frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 64);
    self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [self.collectionView registerClass:[NineTableCollectionCell class] forCellWithReuseIdentifier:@"NineTableCollectionCell"];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        CurrentPage = 1;
        [self.array removeAllObjects];
        [self getDataWithPage:CurrentPage Success:^(NSArray *array) {
            
            [self hideMessageAction];
            [self.collectionView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            NSLog(@"array = %@",self.array);
            [self.collectionView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self showEmptyViewWithMessage:errorMsg];
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getDataWithPage:CurrentPage Success:^(NSArray *array) {
            [self.collectionView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.collectionView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:errorMsg];
        }];
    }];
    
}

/**
 刷新第一条数据

 @param page 页码
 @param success 成功
 @param fail 失败
 */
- (void)getDataWithPage:(int)page Success:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/cateTemp?cid=%@&page=%d&page_size=12",self.model.cid,page];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [MobanInfoModel mj_objectArrayWithKeyValuesArray:result];
            int page_count = [[[responseObject objectForKey:@"page_count"] description] intValue];
            NSLog(@"page_count = %d",page_count);
            NSLog(@"CurrentPage = %d",CurrentPage);
            if (modelArray.count >= 1) {
                if (page_count <= CurrentPage) {
                    success(modelArray);
                    CurrentPage++;
                    // 没有了
                    if (CurrentPage > 2) {
                        [MBProgressHUD showNormal:@"全部加载完毕"];
                    }else{
                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else if(page_count > CurrentPage){
                    // 还有更多
                    CurrentPage++;
                    success(modelArray);
                }else{
                    fail(@"暂无更多模板");
                }
                
            }else{
                fail(@"暂无更多模板");
            }
        }else{
            fail(message);
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
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



- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

@end
