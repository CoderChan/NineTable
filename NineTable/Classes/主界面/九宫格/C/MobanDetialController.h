//
//  MobanDetialController.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface MobanDetialController : SuperViewController

// 直接有模板信息初始化
- (instancetype)initWithModel:(MobanInfoModel *)model;
// 需要根据模板ID查询模型信息
- (instancetype)initWithMobanID:(ResendWarnModel *)model;

@end
