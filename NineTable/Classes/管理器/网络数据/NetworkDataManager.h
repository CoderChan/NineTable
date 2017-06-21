//
//  NetworkDataManager.h
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeDataModel.h"
#import "CateMaterModel.h"
#import "CreateMobanModel.h"
#import "TeamMemberModel.h"
#import "VIPInfoModel.h"
#import "WechatPayInfoModel.h"
#import "ResendWarnModel.h"
#import "Account.h"
#import "SysterMsgModel.h"


typedef void (^SuccessBlock)();
typedef void(^FailBlock)(NSString *errorMsg);
typedef void (^SuccessModelBlock)(NSArray *array);



@interface NetworkDataManager : NSObject

// 单例初始化
+ (instancetype)sharedManager;

#pragma mark - 用户板块
// 获取注册时的验证码
- (void)getCodeWithPhone:(NSString *)phone Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 手机号码注册
- (void)registerWithPhone:(NSString *)phone Pass:(NSString *)pass Code:(NSString *)codeNum Success:(void (^)(int code))success Fail:(FailBlock)fail;
// 修改密码
- (void)changePassWithPhone:(NSString *)phone Pass:(NSString *)pass Code:(NSString *)codeNum Success:(void (^)(int code))success Fail:(FailBlock)fail;
// 手机号码登录
- (void)loginWithPhone:(NSString *)phone Pass:(NSString *)pass Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 根据用户ID获取用户信息
- (void)getUserModelByAccount:(Account *)account Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 上传用户头像
- (void)uploadHeadWithImage:(UIImage *)image Progress:(void (^)(NSProgress *progress))progress Success:(void (^)(NSString *headUrl))success Fail:(FailBlock)fail;
// 修改性别
- (void)updateSex:(NSString *)sex Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 修改昵称
- (void)updateName:(NSString *)nickName Success:(SuccessBlock)success Fail:(FailBlock)fail;

// 退出登录、切换账号
- (void)returnAccountCompletion:(void (^)())completion;

// VIP套餐列表
- (void)vipListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 获取微信支付的信息
- (void)getWechatPayInfoWithModel:(VIPInfoModel *)vipModel Success:(void (^)(WechatPayInfoModel *wechatPayInfo))success Fail:(FailBlock)fail;
// 查询支付结果
- (void)payResultWithModel:(WechatPayInfoModel *)payModel Success:(SuccessBlock)success Fail:(FailBlock)fail;

#pragma mark - 首页九宫格
// 获取首页全部数据
- (void)getHomeDataSuccess:(void (^)(HomeDataModel *homeModel))success Fail:(FailBlock)fail;
// 转发提醒
- (void)warnMemberWithModel:(MobanInfoModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 搜索模板
- (void)searchMobanWithKeyWord:(NSString *)keyWord Success:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 获取转发模板提醒列表
- (void)reSendWarnListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 转发提醒列表：根据模板ID查询模型信息
- (void)mobanDetialByModel:(ResendWarnModel *)warnModel Success:(void (^)(MobanInfoModel *model))success Fail:(FailBlock)fail;
// 系统消息：邀请加入团队消息推送列表
- (void)systermMsgListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;



#pragma mark - 关注板块
// 关注列表
- (void)getCareListInfoSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 编辑关注列表
- (void)editCareListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 添加关注
- (void)addCareWithModel:(MobanClassModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 取消关注
- (void)cancleCareWithModel:(MobanClassModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;



#pragma mark - 团队板块
// 获取分类图标素材
- (void)getCateMaterialSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 选择本地图片创建分类
- (void)createMobanCateWithPhoto:(UIImage *)image CateName:(NSString *)cateName Desc:(NSString *)cateDesc Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 创建分类
- (void)createMobanCateWithMaterl:(NSString *)iconUrl CateName:(NSString *)cateName Desc:(NSString *)cateDesc Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 获取团队分类列表
- (void)teamCateListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 删除某个团队分类
- (void)deleteTeamCateWithModel:(MobanClassModel *)cateModel Success:(SuccessBlock)success Fail:(FailBlock)fail;

// 创建模板（个人、团队）
- (void)createMobanWithModel:(CreateMobanModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 我创建的模板列表
- (void)myCreateMobanListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 我的团队成员列表
- (void)teamMemberListSuccess:(SuccessModelBlock)success Fail:(FailBlock)fail;
// 获取成员详细信息
- (void)memberDetialWithModel:(TeamMemberModel *)model Success:(void (^)(TeamMemberModel *detialModel))success Fail:(FailBlock)fail;
// 管理员删除团队成员
- (void)deleteTeamMember:(TeamMemberModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 添加团队成员
- (void)addMemberWithModel:(TeamMemberModel *)model Name:(NSString *)name Sex:(NSString *)sex Phone:(NSString *)phone Success:(SuccessBlock)success Fail:(FailBlock)fail;
// 更新成员信息
- (void)editMemberWithModel:(TeamMemberModel *)model Success:(SuccessBlock)success Fail:(FailBlock)fail;



@end
