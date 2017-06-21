//
//  RootTabbarController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "RootTabbarController.h"
#import "RootNavgationController.h"
#import "UIBarButtonItem+Extension.h"
#import "HomeViewController.h"
#import "CareViewController.h"
#import "TeamViewController.h"
#import "WoViewController.h"


@interface RootTabbarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
}

- (void)setupSubViews
{
    HomeViewController *vc1 = [[HomeViewController alloc] init];
    [self addChildVC:vc1 Title:@"九宫格" image:@"home_normal_btn" selectedImage:@"home_selected_btn" Tag:1];
    
    CareViewController *vc2 = [[CareViewController alloc] init];
    [self addChildVC:vc2 Title:@"关注" image:@"attention_normal_btn" selectedImage:@"attention_setected_btn" Tag:2];
    
    TeamViewController *vc3 = [[TeamViewController alloc] init];
    [self addChildVC:vc3 Title:@"团队" image:@"team_normal_btn" selectedImage:@"team_selected_btn" Tag:3];
    
    WoViewController *vc4 = [[WoViewController alloc]init];
    [self addChildVC:vc4 Title:@"我的" image:@"me_normal_btn" selectedImage:@"me_setected_btn" Tag:4];
    
    // 设置一些被控制的控制器
    [NineTableManager sharedManager].tabbar = self;
    [NineTableManager sharedManager].homeVC = vc1;
}

#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage Tag:(NSInteger)tag
{
    childVC.title = title;
    childVC.tabBarItem.tag = tag;
    
    // 普通图标
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *textAttres = [NSMutableDictionary dictionary];
    textAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    textAttres[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    // 高亮图标
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *selectTextAttres = [NSMutableDictionary dictionary];
    selectTextAttres[NSForegroundColorAttributeName] = MainColor;
    selectTextAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    
    [childVC.tabBarItem setTitleTextAttributes:textAttres forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttres forState:UIControlStateSelected];
    RootNavgationController *normalNav = [[RootNavgationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:normalNav];
    
}

#pragma mark - 首页双击事件处理
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (tabBarController.selectedIndex != 0) {
        return YES;
    }else{
        //双击处理
        if ([self checkIsDoubleClick:[tabBarController.viewControllers firstObject]]) {
            // 告诉第一个界面双击了，刷新界面
            [[NineTableManager sharedManager].homeVC refreshCollectionAction];
        }
        return YES;
    }
}

- (BOOL)checkIsDoubleClick:(UIViewController *)viewController
{
    static UIViewController *lastViewController = nil;
    static NSTimeInterval lastClickTime = 0;
    
    if (lastViewController != viewController) {
        lastViewController = viewController;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        
        return NO;
    }
    
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.5 ) {
        lastClickTime = clickTime;
        return NO;
    }
    
    lastClickTime = clickTime;
    return YES;
}


@end
