//
//  NSString+Category.h
//  FYQ
//
//  Created by Chan_Sir on 2017/2/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

// 定义一个延展，判断字符是否为中文
- (BOOL)isChinese;
// 判断子串串是否为手机号码
- (BOOL)isPhoneNum;
//  8-16位密码字符串。S{8,16}	   [a-z][A-Z][0-9]	   Abc123
- (BOOL)isRealPwd;
//  支付密码---6位纯数字
- (BOOL)isChenkNum;
//  网络缓存
- (NSString *)MD5Hash;

- (NSString *)decodeString:(NSString*)encodedString;

@end
