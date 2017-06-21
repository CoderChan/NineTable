//
//  UIViewController+Category.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UIViewController+Category.h"

@interface UIViewController ()


@end

@implementation UIViewController (Category)



#pragma mark - AlertView提示
- (void)sendAlertAction:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
#pragma mark - 单个alertView的回调提示
- (void)showOneAlertWithMessage:(NSString *)message ConfirmClick:(void (^)())clickBlock
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        clickBlock();
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

#pragma mark - 双按钮的alertView
- (void)showTwoAlertWithMessage:(NSString *)message ConfirmClick:(void (^)())clickBlock
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        clickBlock();
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

#pragma mark - 数据异常的显示
- (void)showEmptyViewWithMessage:(NSString *)message
{
    
}
- (void)hideMessageAction
{
    
}

#pragma mark - 闪烁灯效果
- (CABasicAnimation *)AlphaLight:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // kCAMediaTimingFunctionEaseIn
    return animation;
}
#pragma mark - 数组随机排序
- (NSArray *)randomizedArrayWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc]initWithArray:array];
    
    NSUInteger i = [results count];
    
    while(--i > 0) {
        
        int j = rand() % (i+1);
        
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
        
    }
    NSArray *resultArray = results;
    return resultArray;
}
#pragma mark - 查看APP权限设置
- (void)openSettingWithTips:(NSString *)tips
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}




@end
