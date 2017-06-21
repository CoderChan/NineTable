//
//  HTTPLimiteCache.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPLimiteCache : NSObject

{
    NSTimeInterval myTime;//设置缓存的有效时间
}

//创建单利
+ (instancetype)shareInstance;
//存缓存
- (void)saveWithData:(NSData *)data andNameString:(NSString *)urlString;
//读取缓存
- (NSData *)getDataWithNameString:(NSString *)urlString;



@end
