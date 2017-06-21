//
//  HomeDataModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobanClassModel.h"
#import "MobanInfoModel.h"
#import "LunbotuModel.h"

// 首页的数据模型
@interface HomeDataModel : NSObject

// 顶部轮播图内容
@property (copy,nonatomic) NSArray *banner;
// 分类数据
@property (copy,nonatomic) NSArray *category;
// 最新模板
@property (copy,nonatomic) NSArray *template;

@end
