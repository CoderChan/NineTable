//
//  SelectCateIconView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SelectCateIconView.h"
#import "CateIconCollectionCell.h"

#define SpaceNum 15
#define HangCout 4
#define LieCount 3


@interface SelectCateIconView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;



@end

@implementation SelectCateIconView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - 代理方法
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
    CateMaterModel *model = self.array[indexPath.row];
    CateIconCollectionCell *cell = [CateIconCollectionCell sharedCell:collectionView IndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateMaterModel *model = self.array[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectCateIconWithModel:)]) {
        [_delegate selectCateIconWithModel:model];
        [self removeFromSuperview];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(60*CKproportion, 60*CKproportion);
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SpaceNum, SpaceNum, SpaceNum, SpaceNum);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SpaceNum;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return SpaceNum;
}
- (UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = SpaceNum;
    flowLayout.minimumInteritemSpacing = SpaceNum;
    
    CGFloat Fwidth = 60*CKproportion;
    CGFloat Fheight = 60*CKproportion;
    CGFloat Width = (LieCount + 1)*SpaceNum + Fwidth * LieCount;
    CGFloat Height = (HangCout + 1)*SpaceNum + Fheight * HangCout;
    CGFloat X = (SCREEN_WIDTH - Width)/2;
    CGFloat Y = (SCREEN_HEIGHT - Height)/2;
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(X, Y, Width, Height) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CateIconCollectionCell class] forCellWithReuseIdentifier:@"CateIconCollectionCell"];
    }
    return _collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}


@end
