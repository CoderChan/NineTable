//
//  SuperViewController.h
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperViewController : UIViewController

/** 显示POP提示 */
- (void)showPopTipsWithMessage:(NSString *)message AtView:(UIView *)atView inView:(UIView *)inView;
/** 网络数据为空或其他异常时，把message显示在视图上 */
- (void)showEmptyViewWithMessage:(NSString *)message;
/** 隐藏message */
- (void)hideMessageAction;

@end
