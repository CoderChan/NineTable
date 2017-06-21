//
//  CateIconCollectionCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateIconCollectionCell : UICollectionViewCell

@property (strong,nonatomic) CateMaterModel *model;

/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

@end
