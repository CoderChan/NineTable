//
//  UserInfoModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

/** 用户ID */
@property (copy,nonatomic) NSString *uid;
/** 用户名 */
@property (copy,nonatomic) NSString *uname;
/** 昵称 */
@property (copy,nonatomic) NSString *nick_name;
/** 用户身份---0：超级管理员，1：管理员，2：授权用户，3：普通用户   */
@property (assign,nonatomic) int type;
/** 签名 */
@property (copy,nonatomic) NSString *sign;
/** 团队ID */
@property (copy,nonatomic) NSString *tid;
/** 性别 */
@property (copy,nonatomic) NSString *sex;
/** 头像地址 */
@property (copy,nonatomic) NSString *header_img;
/** 电话号码 */
@property (copy,nonatomic) NSString *phone;
/** VIP购买时间 */
@property (copy,nonatomic) NSString *start_time;
/** VIP截止时间 */
@property (copy,nonatomic) NSString *end_time;

@end
