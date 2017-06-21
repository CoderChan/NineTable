//
//  CateIconCollectionCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CateIconCollectionCell.h"


@interface CateIconCollectionCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *fopaiImgView;

@end

@implementation CateIconCollectionCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CateIconCollectionCell";
    CateIconCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[CateIconCollectionCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setModel:(CateMaterModel *)model
{
    _model = model;
    [_fopaiImgView sd_setImageWithURL:[NSURL URLWithString:model.lcon] placeholderImage:[UIImage imageNamed:@"class_0"]];
}

- (void)setupSubViews
{
    
    self.fopaiImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_0"]];
    self.fopaiImgView.frame = self.bounds;
    [self.contentView addSubview:self.fopaiImgView];
    
}


@end
