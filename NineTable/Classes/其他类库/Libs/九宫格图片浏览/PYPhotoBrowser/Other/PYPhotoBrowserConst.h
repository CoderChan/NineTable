//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  用于存储常量、宏定义的头文件

#import <UIKit/UIKit.h>


/** --------------可修改(在PYConst.m修改)------------- */
#define PYPlaceholderImage [UIImage imageNamed:@"image_place"] // 占位图
#define PYLoadFailureImage [UIImage imageNamed:@"PYPhotosView.bundle/imageerror"] // 加载失败图(添加在占位图上大小默认为100 * 100)
#define PYAddImage [UIImage imageNamed:@"PYPhotosView.bundle/addimage"] // 添加图片图
#define PYDeleteImage [UIImage imageNamed:@"PYPhotosView.bundle/deleteimage"] // 删除图片图



extern const CGFloat PYPhotoMargin;   //图片之间的默认间距(默认为5)
extern const CGFloat PYPhotoWidth;    // 图片的默认宽度
extern const CGFloat PYPhotoHeight;    // 图片的默认高度

extern const CGFloat PYPhotosMaxCol;  // 图片每行默认最多个数（默认为3）
extern const CGFloat PYPreviewPhotoSpacing;   // 预览图片时，图片的间距（默认为30）
extern const CGFloat PYPreviewPhotoMaxScale;  // 预览图片时，图片最大放大倍数（默认为2）
extern const CGFloat PYImagesMaxCountWhenWillCompose; // 在发布状态时，最多可以上传的图片张数（默认为9）



/** ---------------建议不修改的宏定义------------- */

// 屏幕宽高
// 屏幕宽高(注意：由于不同iOS系统下，设备横竖屏时屏幕的高度和宽度有的是变化的有的是不变的)
#define PYRealyScreenW [UIScreen mainScreen].bounds.size.width
#define PYRealyScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽高（这里获取的是正常竖屏的屏幕宽高（宽永远小于高度））
#define PYScreenW (PYRealyScreenW < PYRealyScreenH ? PYRealyScreenW : PYRealyScreenH)
#define PYScreenH (PYRealyScreenW > PYRealyScreenH ? PYRealyScreenW : PYRealyScreenH)
#define PYScreenSize CGSizeMake(PYScreenW, PYScreenH)

// 判断当前系统版本
#define PYIOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 9.0
#define PYIOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0

extern NSString *const PYPhotoBrowseViewKey; // 自定义时，取出PYPhotoBrowseView的Key

/** ---------------自定义通知------------- */
extern NSString *const PYBigImageDidClikedNotification;       // 大图被点击（缩小）
extern NSString *const PYSmallgImageDidClikedNotification;    // 小图被点击（放大）
extern NSString *const PYImagePageDidChangedNotification;     // 浏览过程中的图片被点击（放回原位）
extern NSString *const PYPreviewImagesDidChangedNotification; // 预览图片被点击
extern NSString *const PYChangeNavgationBarStateNotification; // 改变状态栏
extern NSString *const PYAddImageDidClickedNotification;      // 添加图片被点击
extern NSString *const PYCollectionViewDidScrollNotification; // 滚动通知


