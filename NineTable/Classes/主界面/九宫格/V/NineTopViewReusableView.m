//
//  NineTopViewReusableView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NineTopViewReusableView.h"
#import <Masonry.h>
#import <UIButton+WebCache.h>
#import "CateIconView.h"
#import <SDCycleScrollView.h>


@interface NineTopViewReusableView ()<SDCycleScrollViewDelegate>

/** 装着按钮的数组 */
@property (strong,nonatomic) NSMutableArray *subViewsArray;
// 轮播
@property (strong,nonatomic) SDCycleScrollView *scrollView;

@end

@implementation NineTopViewReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)setHomeModel:(HomeDataModel *)homeModel
{
    _homeModel = homeModel;
    for (CateIconView *button in self.subViewsArray) {
        [button removeFromSuperview];
    }
    
    // 轮播图
    [self addSubview:self.scrollView];
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *iconArray = [NSMutableArray array];
    for (int i = 0; i < homeModel.banner.count; i++) {
        LunbotuModel *lunboModel = homeModel.banner[i];
        [nameArray addObject:lunboModel.name];
        [iconArray addObject:lunboModel.img];
    }
    self.scrollView.titlesGroup = nameArray;
    self.scrollView.imageURLStringsGroup = iconArray;
    
    
    if (homeModel.category.count > 0) {
        
        NSMutableArray *mobanArray = [NSMutableArray array];
        MobanClassModel *allClassModel = [[MobanClassModel alloc]init];
        allClassModel.name = @"全部分类";
        allClassModel.lcon = @"www.baidu.com";
        allClassModel.cid = @"all";
        allClassModel.isAllMoBan = YES;
        
        if (homeModel.category.count > 9) {
            // 大于9个的时候只取前9个，最好一个是全部模板
            for (int i = 0; i < homeModel.category.count; i++) {
                MobanClassModel *model = homeModel.category[i];
                if (i < 9) {
                    [mobanArray addObject:model];
                }
            }
            [mobanArray addObject:allClassModel];
        }else{
            // 1-9个的时候，直接添加一个全部模板
            
            [mobanArray addObjectsFromArray:homeModel.category];
            [mobanArray addObject:allClassModel];
        }
        [self addSubViewsWithArray:mobanArray];
    }else{
        
    }
}

// 排类分类图标
- (void)addSubViewsWithArray:(NSArray *)mobanAlassArray
{
    
    CGFloat spaceH = 8 * CKproportion; // 横向间距
    CGFloat spaceZ = 15 * CKproportion; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*6)/5;  // 宽
    CGFloat H = (180*CKproportion - spaceZ*3)/2; // 高
    
    for (int i = 0; i < mobanAlassArray.count; i++) {
        
        CGRect frame;
        frame.size.width = W;
        frame.size.height = H ;
        frame.origin.x = (i%5) * (frame.size.width + spaceH) + spaceH;
        frame.origin.y = floor(i/5) * (frame.size.height + spaceZ) + spaceZ + self.scrollView.height;
        
        MobanClassModel *model = mobanAlassArray[i];
        
        CateIconView *iconView = [[CateIconView alloc]initWithFrame:frame];
        iconView.careModel = model;
        iconView.ClickBlock = ^(MobanClassModel *cateModel) {
            if ([self.delegate respondsToSelector:@selector(nineTopViewClickWithModel:)]) {
                [_delegate nineTopViewClickWithModel:cateModel];
            }
        };
        [self addSubview:iconView];
        [self.subViewsArray addObject:iconView];
        
    }
}

- (NSMutableArray *)subViewsArray
{
    if (!_subViewsArray) {
        _subViewsArray = [NSMutableArray array];
    }
    return _subViewsArray;
}

- (SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - 44) * 0.3) delegate:self placeholderImage:[UIImage imageWithColor:HWRandomColor]];
    }
    return _scrollView;
}


@end
