//
//  MobanDetialController.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef enum : NSUInteger {
    YLRMSharePlatformTypeSina               = 0, //新浪
    YLRMSharePlatformTypeWechatSession      = 1, //微信聊天
    YLRMSharePlatformTypeWechatTimeLine     = 2,//微信朋友圈
    YLRMSharePlatformTypeWechatFavorite     = 3,//微信收藏
    YLRMSharePlatformTypeQQ                 = 4,//QQ聊天页面
    YLRMSharePlatformTypeQzone              = 5,//qq空间
    YLRMSharePlatformTypeTencentWb          = 6,//腾讯微博
    YLRMSharePlatformTypeAlipaySession      = 7,//支付宝聊天页面
    YLRMSharePlatformTypeSms                = 13,//短信
    YLRMSharePlatformTypeEmail              = 14,//邮件
    YLRMSharePlatformTypeOther              = 15,//未知平台
} YLRMSharePlatformType;


@interface MobanDetialController : SuperViewController

// 直接有模板信息初始化
- (instancetype)initWithModel:(MobanInfoModel *)model;
// 需要根据模板ID查询模型信息
- (instancetype)initWithMobanID:(ResendWarnModel *)model;

@end
