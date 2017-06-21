//
//  MobanClassModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobanClassModel : NSObject

/** 分类ID */
@property (copy,nonatomic) NSString *cid;
/** 名字 */
@property (copy,nonatomic) NSString *name;
/** 分类图标地址 */
@property (copy,nonatomic) NSString *lcon;

// 是否为全部模板
@property (assign,nonatomic) BOOL isAllMoBan;
// 是否关注
@property (assign,nonatomic) BOOL satus;
// 索引
@property (assign,nonatomic) NSInteger index;

@end
