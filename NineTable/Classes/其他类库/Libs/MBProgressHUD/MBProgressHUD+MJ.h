//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)

// 普通样式
+ (void)showNormal:(NSString *)tips;
// 成功
+ (void)showSuccess:(NSString *)success;
// 错误
+ (void)showError:(NSString *)error;


// 加载中
+ (MBProgressHUD *)showMessage:(NSString *)message;
// 隐藏
+ (void)hideHUD;

///其他
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;


@end
