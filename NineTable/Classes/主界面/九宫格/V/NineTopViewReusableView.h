//
//  NineTopViewReusableView.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NineTopViewDelegate <NSObject>

- (void)nineTopViewClickWithModel:(MobanClassModel *)classModel;

@end

@interface NineTopViewReusableView : UICollectionReusableView

/** 点击分类按钮 */
@property (weak,nonatomic) id<NineTopViewDelegate> delegate;
/** 数据源 */
@property (strong,nonatomic) HomeDataModel *homeModel;



@end
