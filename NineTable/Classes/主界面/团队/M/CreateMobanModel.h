//
//  CreateMobanModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateMobanModel : NSObject

// 模板名称
@property (copy,nonatomic) NSString*mobanName;
// 模板配文
@property (copy,nonatomic) NSString *mobanDesc;
// 团队ID
@property (copy,nonatomic) NSString *team_id;
// 图片数组
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

// 分类ID
@property (copy,nonatomic) NSString *cateID;
// 是否共享
@property (assign,nonatomic) BOOL isShare;
// 分类
@property (copy,nonatomic) NSString *cid;

@end
