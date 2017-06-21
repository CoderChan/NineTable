//
//  WechatPayInfoModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatPayInfoModel : NSObject

@property (copy,nonatomic) NSString *appid;

@property (copy,nonatomic) NSString *noncestr;

@property (copy,nonatomic) NSString *package;

@property (copy,nonatomic) NSString *prepayid;

@property (copy,nonatomic) NSString *partnerid;

@property (copy,nonatomic) NSString *timestamp;

@property (copy,nonatomic) NSString *sign;

@property (copy,nonatomic) NSString *packagestr;

@property (copy,nonatomic) NSString *order_no;

@end
