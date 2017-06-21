//
//  RootNavgationController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "RootNavgationController.h"

@interface RootNavgationController ()

@end

@implementation RootNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (void)initialize
{
//    [UINavigationBar appearanceWhenContainedIn:self, nil];
    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:NavColor];
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil]];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {    // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
