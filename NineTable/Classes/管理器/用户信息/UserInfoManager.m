//
//  UserInfoManager.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

#pragma mark - 单例初始化
+ (instancetype)sharedManager
{
    static UserInfoManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
#pragma mark - 保存数据
- (void)saveUserInfo:(UserInfoModel *)userModel Success:(void (^)())success Fail:(void (^)(NSString *))fail
{
    [self removeDataSave];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userModel.uid forKey:@"uid"];
    if (!userModel.tid) {
        userModel.tid = @"teamID";
    }
    [dict setValue:userModel.tid forKey:@"tid"];
    Account *account = [Account accountWithDict:dict];
    [AccountTool saveAccount:account];
    
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:userModel.uid forKey:UuserID];
    [UD setObject:userModel.uname forKey:Uuname];
    [UD setObject:userModel.nick_name forKey:Unick_name];
    [UD setObject:[NSString stringWithFormat:@"%d",userModel.type] forKey:Utype];
    [UD setObject:userModel.sign forKey:Usign];
    [UD setObject:userModel.tid forKey:Utid];
    [UD setObject:userModel.sex forKey:Usex];
    [UD setObject:userModel.header_img forKey:Uheader_img];
    [UD setObject:userModel.phone forKey:Uphone];
    [UD setObject:userModel.start_time forKey:Ustart_time];
    [UD setObject:userModel.end_time forKey:Uend_time];
    
    
    [UD synchronize];
    
    UserInfoModel *checkModel = [self getUserInfo];
    if (checkModel.uid) {
        success();
    }else{
        fail(@"信息缓存失败，请重新登录");
    }
    
}
#pragma mark - 更新缓存
- (void)updateWithKey:(NSString *)key Value:(NSString *)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:value forKey:key];
    [UD synchronize];
}

#pragma mark - 清除缓存
- (void)removeDataSave
{
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    // 用户信息
    [UD removeObjectForKey:UuserID];
    [UD removeObjectForKey:Uuname];
    [UD removeObjectForKey:Unick_name];
    [UD removeObjectForKey:Utype];
    [UD removeObjectForKey:Usign];
    [UD removeObjectForKey:Utid];
    [UD removeObjectForKey:Usex];
    [UD removeObjectForKey:Uheader_img];
    [UD removeObjectForKey:Uphone];
    [UD removeObjectForKey:Ustart_time];
    [UD removeObjectForKey:Uend_time];
    
    
    // 其他缓存
    
}

#pragma mark - 获取用户模型
- (UserInfoModel *)getUserInfo
{
    UserInfoModel *userModel = [[UserInfoModel alloc]init];
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSString *userID = [UD objectForKey:UuserID];
    NSString *uname = [UD objectForKey:Uuname];
    NSString *nick_name = [UD objectForKey:Unick_name];
    NSString *type = [UD objectForKey:Utype];
    NSString *sign = [UD objectForKey:Usign];
    NSString *tid = [UD objectForKey:Utid];
    NSString *sex = [UD objectForKey:Usex];
    NSString *head_img = [UD objectForKey:Uheader_img];
    NSString *phone = [UD objectForKey:Uphone];
    NSString *start_time = [UD objectForKey:Ustart_time];
    NSString *end_time = [UD objectForKey:Uend_time];
    
    
    userModel.uid = userID;
    userModel.uname = uname;
    userModel.nick_name = nick_name;
    userModel.type = [type intValue];
    userModel.sign = sign;
    userModel.tid = tid;
    userModel.sex = sex;
    userModel.header_img = head_img;
    userModel.phone = phone;
    userModel.start_time = start_time;
    userModel.end_time = end_time;
    
    return userModel;
}


@end
