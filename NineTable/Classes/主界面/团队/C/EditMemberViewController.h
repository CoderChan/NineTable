//
//  EditMemberViewController.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface EditMemberViewController : SuperViewController

// 传入一个成员模型
- (instancetype)initWithModel:(TeamMemberModel *)model;
// 删除成员成功的回调
@property (copy,nonatomic) void (^DeleteMemberBlock)();

@end
