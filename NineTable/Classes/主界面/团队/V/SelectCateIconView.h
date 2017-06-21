//
//  SelectCateIconView.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectIconDelegate <NSObject>

- (void)selectCateIconWithModel:(CateMaterModel *)cateIconModel;

@end

@interface SelectCateIconView : UIView



@property (copy,nonatomic) NSArray *array;

/**
 代理
 */
@property (weak,nonatomic) id<SelectIconDelegate> delegate;

@end
