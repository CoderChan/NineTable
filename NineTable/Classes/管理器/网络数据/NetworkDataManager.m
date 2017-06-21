//
//  NetworkDataManager.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NetworkDataManager.h"
#import "HTTPManager.h"
#import "NineTableManager.h"
#import "UserInfoManager.h"
#import <MJExtension/MJExtension.h>
#import <JPUSHService.h>



@implementation NetworkDataManager

#pragma mark - 初始化
+ (instancetype)sharedManager
{
    static NetworkDataManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 用户相关
- (void)getCodeWithPhone:(NSString *)phone Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/verityCode";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phone forKey:@"phone"];
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"验证码返回 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 手机号码注册
- (void)registerWithPhone:(NSString *)phone Pass:(NSString *)pass Code:(NSString *)codeNum Success:(void (^)(int))success Fail:(FailBlock)fail
{
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/register";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phone forKey:@"phone"];
    [param setValue:pass forKey:@"password"];
    [param setValue:codeNum forKey:@"verity_code"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"注册返回 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 0) {
            fail(message);
        }else{
            if (code == 1) {
                // 保存用户信息
                NSDictionary *result = [responseObject objectForKey:@"result"];
                UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
                [self saveUserInfo:userModel Success:^{
                    success(code);
                } Fail:^(NSString *errorMsg) {
                    [[NineTableManager sharedManager].userManager removeDataSave];
                    fail(@"信息保存失败，请重试");
                }];
                
            }else{
                success(code);
            }
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 修改密码
- (void)changePassWithPhone:(NSString *)phone Pass:(NSString *)pass Code:(NSString *)codeNum Success:(void (^)(int))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/updatePassword";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:phone forKey:@"phone"];
    [param setValue:pass forKey:@"password"];
    [param setValue:codeNum forKey:@"verity_code"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改密码返回 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            success(code);
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 手机号码登录
- (void)loginWithPhone:(NSString *)phone Pass:(NSString *)pass Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/login";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phone forKey:@"phone"];
    [param setValue:pass forKey:@"password"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"登录返回 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            // 保存用户信息
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success(code);
            } Fail:^(NSString *errorMsg) {
                [[NineTableManager sharedManager].userManager removeDataSave];
                fail(@"信息保存失败，请重试");
            }];
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
- (void)getUserModelByAccount:(Account *)account Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Login/userDetailed?uid=%@",account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取用户信息 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            // 保存用户信息
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:result];
            [self saveUserInfo:userModel Success:^{
                success(code);
            } Fail:^(NSString *errorMsg) {
                [[NineTableManager sharedManager].userManager removeDataSave];
                fail(@"信息保存失败，请重试");
            }];
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 保存用户信息
- (void)saveUserInfo:(UserInfoModel *)userModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    // 极光推送
    [JPUSHService setTags:[NSSet setWithObject:userModel.tid] aliasInbackground:userModel.uid];
    
    [[NineTableManager sharedManager].userManager saveUserInfo:userModel Success:^{
        success();
    } Fail:^(NSString *errorMsg) {
        fail(errorMsg);
    }];
}
// 退出登录、切换账号
- (void)returnAccountCompletion:(void (^)())completion
{
    [[SDImageCache sharedImageCache] cleanDisk];
    [[NineTableManager sharedManager].userManager removeDataSave];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            if ([fileName isEqualToString:@"t_address.sqlite"]) {
                // 不删除这些。用户信息、离线订单、归档
                
                completion();
                
            }else{
                NSError *error;
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:&error];
                completion();
            }
        }
    }
}

- (void)uploadHeadWithImage:(UIImage *)image Progress:(void (^)(NSProgress *))progress Success:(void (^)(NSString *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }

    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/File/updateHeadImg";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    // 上传头像 模糊度如果是1会出现失败
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *name = @"file";
    NSString *fileName = @"head.jpeg";
    
    
    [HTTPManager uploadWithURL:url params:param fileData:imageData name:name fileName:fileName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        NSLog(@"上传进度 = %f",progress.fractionCompleted);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSString *result = [[responseObject objectForKey:@"result"] description];
            [[UserInfoManager sharedManager] updateWithKey:Uheader_img Value:result];
            success(result);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 修改性别
- (void)updateSex:(NSString *)sex Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/userInformation";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:sex forKey:@"sex"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[NineTableManager sharedManager].userManager updateWithKey:Usex Value:sex];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 修改昵称
- (void)updateName:(NSString *)nickName Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Login/userInformation";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:nickName forKey:@"nick_name"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [[NineTableManager sharedManager].userManager updateWithKey:Unick_name Value:nickName];
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// VIP套餐列表
- (void)vipListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Vip/vipList";
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [VIPInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count >= 1) {
                success(modelArray);
            }else{
                fail(@"还没有VIP套餐");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 获取微信支付的信息
- (void)getWechatPayInfoWithModel:(VIPInfoModel *)vipModel Success:(void (^)(WechatPayInfoModel *))success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"用户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Vip/payment";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:vipModel.id forKey:@"vid"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"微信支付信息 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            WechatPayInfoModel *model = [WechatPayInfoModel mj_objectWithKeyValues:result];
            success(model);
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 查询支付结果
- (void)payResultWithModel:(WechatPayInfoModel *)payModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    
    if (!payModel) {
        
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Vip/payStatus?orderNo=%@",payModel.order_no];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSLog(@"支付后的结果 = %@",responseObject);
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            // 用户信息变更
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSString *tid = [result objectForKey:@"tid"];
            NSString *start_time = [result objectForKey:@"start_time"];
            NSString *end_time = [result objectForKey:@"end_time"];
            NSString *type = [result objectForKey:@"type"];
            
            
            [[UserInfoManager sharedManager] updateWithKey:Utid Value:tid];
            [[UserInfoManager sharedManager] updateWithKey:Ustart_time Value:start_time];
            [[UserInfoManager sharedManager] updateWithKey:Uend_time Value:end_time];
            [[UserInfoManager sharedManager] updateWithKey:Utype Value:type];
            
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

#pragma mark - 首页九宫格
// 获取首页全部数据
- (void)getHomeDataSuccess:(void (^)(HomeDataModel *))success Fail:(FailBlock)fail
{
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Template/homePage";
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            HomeDataModel *homeModel = [HomeDataModel mj_objectWithKeyValues:result];
            success(homeModel);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 转发提醒
- (void)warnMemberWithModel:(MobanInfoModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/forwarRemind?uid=%@&team_id=%@&tid=%@",account.userID,userModel.tid,model.tid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 搜索模板
- (void)searchMobanWithKeyWord:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/searchTemplate?keyword=%@",keyWord];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [MobanInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count >= 1) {
                success(modelArray);
            }else{
                fail(@"查无结果");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 获取转发模板提醒列表
- (void)reSendWarnListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/forwarRemindList?uid=%@",account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArray = [ResendWarnModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
            }else{
                fail(@"您可点击右上角编辑关注");
            }
            
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 转发提醒列表：根据模板ID查询模型信息
- (void)mobanDetialByModel:(ResendWarnModel *)warnModel Success:(void (^)(MobanInfoModel *))success Fail:(FailBlock)fail
{
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/templateDetails?tid=%@",warnModel.tid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            MobanInfoModel *mobanModel = [MobanInfoModel mj_objectWithKeyValues:result];
            success(mobanModel);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 系统消息：邀请加入团队消息推送列表
- (void)systermMsgListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/pushList?uid=%@",account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [SysterMsgModel mj_objectArrayWithKeyValuesArray:result];
            success(modelArray);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

#pragma mark - 关注板块
// 关注列表
- (void)getCareListInfoSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/follow?uid=%@",account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArray = [MobanClassModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
            }else{
                fail(@"您可点击右上角编辑关注");
            }
            
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 编辑关注列表
- (void)editCareListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/categoryList?&uid=%@",account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                NSArray *modelArray = [MobanClassModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
            }else{
                fail(@"暂无数据");
            }
            
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 添加关注
- (void)addCareWithModel:(MobanClassModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/addFollow?cid=%@&uid=%@",model.cid,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 取消关注
- (void)cancleCareWithModel:(MobanClassModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Template/removeFollow?cid=%@&uid=%@",model.cid,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

#pragma mark - 团队板块
// 获取分类图标素材
- (void)getCateMaterialSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Team/material";
    [HTTPManager GETCache:url parameter:nil success:^(id responseObject) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            int code = [[[json objectForKey:@"code"] description] intValue];
            NSString *message = [[json objectForKey:@"message"] description];
            if (code == 1) {
                NSArray *result = [json objectForKey:@"result"];
                
                NSArray *modelArray = [CateMaterModel mj_objectArrayWithKeyValuesArray:result];
                success(modelArray);
                
            }else{
                fail(message);
            }
        }else{
            fail(@"解析失败");
        }
        
    } failure:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 创建分类
- (void)createMobanCateWithPhoto:(UIImage *)image CateName:(NSString *)cateName Desc:(NSString *)cateDesc Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/File/upload";
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    
    
    [HTTPManager uploadWithURL:url params:param fileData:imageData name:@"file" fileName:@"icon.jpeg" mimeType:@"jpeg" progress:^(NSProgress *progress) {
        NSLog(@"上传进度 = %f",progress.fractionCompleted);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"选择相册的 = %@",responseObject);  // 返回404
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSString *result = [responseObject objectForKey:@"result"];
            [self createMobanCateWithMaterl:result CateName:cateName Desc:cateDesc Success:^{
                success();
            } Fail:^(NSString *errorMsg) {
                fail(errorMsg);
            }];
            
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
    
}
// 创建模板分类
- (void)createMobanCateWithMaterl:(NSString *)iconUrl CateName:(NSString *)cateName Desc:(NSString *)cateDesc Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }

    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Team/addCategory";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:account.teamID forKey:@"team_id"];
    [param setValue:cateName forKey:@"name"];
    [param setValue:cateDesc forKey:@"content"];
    [param setValue:iconUrl forKey:@"lcon"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"选择素材的 = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 获取团队分类列表
- (void)teamCateListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/TempCategory?uid=%@&tid=%@",account.userID,userModel.tid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [MobanClassModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count >= 1) {
                success(modelArray);
            }else{
                fail(@"还没有团队模板\r您可成为VIP后建立自己的团队");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 删除某个团队分类
- (void)deleteTeamCateWithModel:(MobanClassModel *)cateModel Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/delTempCategory?uid=%@&cid=%@",account.userID,cateModel.cid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}


// 创建模板（个人、团队）
- (void)createMobanWithModel:(CreateMobanModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Team/addTemplate";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:model.mobanName forKey:@"name"];
    [param setValue:model.mobanDesc forKey:@"content"];
    [param setValue:model.team_id forKey:@"team_id"];
    [param setValue:model.cid forKey:@"cid"];
    [param setValue:[NSString stringWithFormat:@"%d",model.isShare] forKey:@"is_share"];
    for (int i = 0; i < model.images.count; i++) {
        
        UIImage *image = model.images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *baseStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *key = [NSString stringWithFormat:@"file%d",i+1];
        
        [param setValue:baseStr forKey:key];
    }
    
    NSLog(@"param = %@",param);
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 我创建的模板列表
- (void)myCreateMobanListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Own/tempList?uid=%@",account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [MobanInfoModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count >= 1) {
                success(modelArray);
            }else{
                fail(@"还没有您的模板，点击创建吧!");
            }
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 我的团队成员列表
- (void)teamMemberListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/teamMemberList?tid=%@",userModel.tid];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        //NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *modelArray = [TeamMemberModel mj_objectArrayWithKeyValuesArray:result];
            if (modelArray.count >= 1) {
                success(modelArray);
            }else{
                if (userModel.type == 1 || userModel.type == 0) {
                    
                    success(@[]);
                
                }else{
                    fail(@"还没有成员\r前往开通VIP建立你的团队\r或被团队管理员邀请进团");
                }
            }
        }else{
            fail(@"还没有成员\r前往开通VIP建立你的团队\r或被团队管理员邀请进团");
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

// 获取成员详细信息
- (void)memberDetialWithModel:(TeamMemberModel *)model Success:(void (^)(TeamMemberModel *))success Fail:(FailBlock)fail
{
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/detailed?uid=%@",model.uid];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSDictionary *dict = [result firstObject];
            
            TeamMemberModel *resultModel = [TeamMemberModel mj_objectWithKeyValues:dict];
            resultModel.uid = model.uid;
            resultModel.uname = model.uname;
            resultModel.header_img = model.header_img;
            resultModel.phone = model.phone;
            success(resultModel);
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}
// 管理员删除团队成员
- (void)deleteTeamMember:(TeamMemberModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://sjd.wxwkf.com/index.php/Home/Team/delMember?mid=%@&uid=%@",model.uid,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else if (code == 3){
            fail(@"没有权限");
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

// 添加团队成员
- (void)addMemberWithModel:(TeamMemberModel *)model Name:(NSString *)name Sex:(NSString *)sex Phone:(NSString *)phone Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Team/addMember";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"recommend_id"];
    [param setValue:userModel.tid forKey:@"tid"];
    [param setValue:name forKey:@"uname"];
    [param setValue:sex forKey:@"sex"];
    [param setValue:phone forKey:@"phone"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}
// 更新成员信息
- (void)editMemberWithModel:(TeamMemberModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail
{
    Account *account = [AccountTool account];
    if (!account) {
        fail(@"账户未登录");
        return;
    }
    
    NSString *url = @"http://sjd.wxwkf.com/index.php/Home/Team/editMember";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.userID forKey:@"uid"];
    [param setValue:model.uid forKey:@"mid"];
    [param setValue:model.uname forKey:@"uname"];
    [param setValue:model.sex forKey:@"sex"];
    [param setValue:model.phone forKey:@"phone"];
    [param setValue:model.enable_pwd forKey:@"enable_pwd"];
    
    [HTTPManager POST:url params:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            success();
        }else{
            fail(message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error.localizedDescription);
    }];
}

@end
