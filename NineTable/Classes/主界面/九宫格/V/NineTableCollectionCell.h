//
//  NineTableCollectionCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NineTableCollectionCell : UICollectionViewCell

/** 模板模型 */
@property (strong,nonatomic) MobanInfoModel *mobanModel;
/** 初始化 */
+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath;

@end
