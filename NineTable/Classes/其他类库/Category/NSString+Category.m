//
//  NSString+Category.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Category)

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPhoneNum
{
    NSString *match = @"(^[1][3578][0-9]{9}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isRealPwd
{
    NSString *match = @"([a-zA-z]\\w{5,13})";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChenkNum
{
    NSString *match = @"([0-9]{6})";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:self];
}

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


//URLDEcode
- (NSString *)decodeString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


@end
