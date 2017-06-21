//
//  AppDelegate.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AppDelegate.h"
#import "RootNavgationController.h"
#import "RootTabbarController.h"
#import <JPUSHService.h>
#import <WXApi.h>
#import "WXApiManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRootController];
    [self setupThirdSDKWithOptions:launchOptions];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupRootController
{
    
    RootTabbarController *tabbar = [[RootTabbarController alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = NavColor;
    self.window.rootViewController = tabbar;
    
    if ([AccountTool account]) {
        [[NineTableManager sharedManager].netManager getUserModelByAccount:[AccountTool account] Success:^{
            
        } Fail:^(NSString *errorMsg) {
            
        }];
    }
}

- (void)setupThirdSDKWithOptions:(NSDictionary *)launchOptions
{
    // 极光推送
    NSString *apnsCertName = nil;
    BOOL push_isProdution = YES;
#if DEBUG
    apnsCertName = @"nine_push_dev"; // chatdemoui_dev
    push_isProdution = NO; // 开发环境，不推送
#else
    apnsCertName = @"nine_push_store";  // chatdemoui
    push_isProdution = YES; // 生产环境，推送
#endif
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey channel:@"" apsForProduction:push_isProdution];
    
    // 微信SDK
    [WXApi registerApp:WeChatAppID enableMTA:YES];
    
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    
}


#pragma mark - 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送失败 = %@",error.localizedDescription);
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
