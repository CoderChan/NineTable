//
//  AccountTool.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(Account *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型
 */
+ (Account *)account;

@end
