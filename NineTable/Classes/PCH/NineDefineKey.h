//
//  NineDefineKey.h
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#ifndef NineDefineKey_h
#define NineDefineKey_h

// RGB
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
// 蒙蒙的图层
#define CoverColor RGBACOLOR(79, 79, 100, 0.4)
// 随机颜色
#define HWRandomColor RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)

// 设备宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 主色调 FA503C
#define MainColor RGBACOLOR(31, 139, 229, 1)
// 导航控制器颜色
#define NavColor RGBACOLOR(84, 83, 88, 1)
// DisEnbled颜色
#define DisAbledColor RGBACOLOR(108, 80, 77, 1)

// 文字颜色
#define TitleColor RGBACOLOR(0, 0, 0, 1)
// 警告的偏红颜色
#define WarningColor RGBACOLOR(242, 73, 78, 1)
// 控制器背景颜色
#define BackColor RGBACOLOR(235, 235, 241, 1)


// 子线程
#define ZCGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
// 主线程
#define ZCMainQueue dispatch_get_main_queue()
//  比例
#define CKproportion [[UIScreen mainScreen] bounds].size.width/375.0f
//  iOS系统版本
#define iOS_Version [[[UIDevice currentDevice] systemVersion] doubleValue]


#ifdef DEBUG // 处于开发阶段
#define KGLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define KGLog(...)
#endif

#define LogFuncName KGLog(@"___%s___",__func__);

#endif /* NineDefineKey_h */
