//
//  AllCateListViewController.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface AllCateListViewController : SuperViewController

- (instancetype)initWithModel:(HomeDataModel *)homeModel;

/** 刷新模板列表的回调 */
@property (copy,nonatomic) void (^ReloadCareListBlock)(HomeDataModel *homeModel);

@end
