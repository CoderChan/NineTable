//
//  CateIconView.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateIconView : UIView

// 模板分类模型
@property (strong,nonatomic) MobanClassModel *careModel;
// 点击回调
@property (copy,nonatomic) void (^ClickBlock)(MobanClassModel *cateModel);

@end
