//
//  HomeDataModel.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "HomeDataModel.h"
#import <MJExtension/MJExtension.h>


@implementation HomeDataModel


+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    HomeDataModel *homeModel = [super mj_objectWithKeyValues:keyValues];
    
    // 轮播图
    NSMutableArray *arrayArray = [NSMutableArray array];
    NSArray *banner = [homeModel.banner copy];
    for (NSDictionary *dic in banner) {
        LunbotuModel *banner = [LunbotuModel mj_objectWithKeyValues:dic];
        
        [arrayArray addObject:banner];
    }
    homeModel.banner = arrayArray;
    
    // 分类数据
    NSMutableArray *categoryArray = [NSMutableArray array];
    NSArray *category = [homeModel.category copy];
    for (NSDictionary *dic in category) {
        MobanClassModel *banner = [MobanClassModel mj_objectWithKeyValues:dic];
        
        [categoryArray addObject:banner];
    }
    homeModel.category = categoryArray;
    
    // 最新模板
    NSMutableArray *templateArray = [NSMutableArray array];
    NSArray *template = [homeModel.template copy];
    for (NSDictionary *dic in template) {
        MobanInfoModel *banner = [MobanInfoModel mj_objectWithKeyValues:dic];
        
        [templateArray addObject:banner];
    }
    homeModel.template = templateArray;
    
    return homeModel;
    
}


@end
