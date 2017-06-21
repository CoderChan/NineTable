//
//  SysterMsgModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysterMsgModel : NSObject

// 消息id
@property (copy,nonatomic) NSString *join_id;
// 用户id
@property (copy,nonatomic) NSString *uid;
// 推荐人ID
@property (copy,nonatomic) NSString *recommend_id;
// 内容
@property (strong,nonatomic) NSString *content;
// 是否同意
@property (assign,nonatomic) BOOL is_agree;



@end
