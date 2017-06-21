//
//  NineConstKey.h
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************  通知及监听 关键字  *****************/
#define YLNotificationCenter [NSNotificationCenter defaultCenter]


// 用户信息的键
extern NSString *const UuserID; // 用户ID
extern NSString *const Uuname; // 用户名
extern NSString *const Unick_name; // 用户昵称
extern NSString *const Utype; // 身份类别
extern NSString *const Usign; // 签名
extern NSString *const Utid; // 团队ID
extern NSString *const Usex; // 性别
extern NSString *const Uheader_img; // 头像
extern NSString *const Uphone; // 电话
extern NSString *const Ustart_time; // vip开始时间
extern NSString *const Uend_time; // vip截止时间

extern NSString *const WeChatPayResultErrCodeKey; // 键
extern NSString *const WechatPayResultNoti;  // 微信支付后的回调


NS_ASSUME_NONNULL_END
