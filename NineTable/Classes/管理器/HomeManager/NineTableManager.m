//
//  NineTableManager.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NineTableManager.h"

@implementation NineTableManager

+ (instancetype)sharedManager
{
    static NineTableManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userManager = [UserInfoManager sharedManager];
        self.netManager = [NetworkDataManager sharedManager];
    }
    return self;
}

@end
