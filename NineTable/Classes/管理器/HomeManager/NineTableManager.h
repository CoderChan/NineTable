//
//  NineTableManager.h
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDataManager.h"
#import "UserInfoManager.h"
#import "NetworkDataManager.h"
#import "HomeViewController.h"
#import "RootTabbarController.h"


@interface NineTableManager : NSObject

/** 初始化 */
+ (instancetype)sharedManager;

/** 用户信息相关 */
@property (strong,nonatomic) UserInfoManager *userManager;
/** 网络请求 */
@property (strong,nonatomic) NetworkDataManager *netManager;

/** 首页 */
@property (weak,nonatomic) HomeViewController *homeVC;
/** tabbar */
@property (weak,nonatomic) RootTabbarController *tabbar;

@end
