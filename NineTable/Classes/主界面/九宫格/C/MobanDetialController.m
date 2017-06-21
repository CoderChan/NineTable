//
//  MobanDetialController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MobanDetialController.h"
#import "PYPhotoBrowser.h"
#import "CMPopTipView.h"
#import "PYPhoto.h"
#import "UIView+Toast.h"
#import <Social/Social.h>


static NSString *const SLServiceTypeWechat = @"com.tencent.xin.sharetimeline";
static NSString *const SLServiceTypeQQ = @"com.tencent.mqq.ShareExtension";
static NSString *const SLServiceTypeAlipay = @"com.alipay.iphoneclient.ExtensionSchemeShare";
static NSString *const SLServiceTypeSms = @"com.apple.UIKit.activity.Message";
static NSString *const SLServiceTypeEmail = @"com.apple.UIKit.activity.Mail";

@interface MobanDetialController ()

// 模板模型
@property (strong,nonatomic) MobanInfoModel *mobanModel;
// 文字说明
@property (strong,nonatomic) UITextView *descTextView;
// 九宫格
@property (strong,nonatomic) PYPhotosView *photosView;

@end

@implementation MobanDetialController

- (instancetype)initWithModel:(MobanInfoModel *)model
{
    self = [super init];
    if (self) {
        self.mobanModel = model;
    }
    return self;
}
- (instancetype)initWithMobanID:(ResendWarnModel *)model
{
    self = [super init];
    if (self) {
        // 根据模板ID查询模板信息
        [[NineTableManager sharedManager].netManager mobanDetialByModel:model Success:^(MobanInfoModel *model) {
            self.mobanModel = model;
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.mobanModel.template_name;
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_warin"] style:UIBarButtonItemStylePlain target:self action:@selector(tipAction)];
    
    // 文字说明
    self.descTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.view.width - 40, 100)];
    self.descTextView.editable = NO;
    self.descTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descTextView.text = self.mobanModel.template_content;
    self.descTextView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.descTextView];
    
    // 九宫格
    self.photosView = [PYPhotosView photosViewWithThumbnailUrls:self.mobanModel.imgurl originalUrls:self.mobanModel.imgurl photosMaxCol:3];
    CGFloat W = (self.view.width - 4 * _photosView.photoMargin)/3 - 30*CKproportion;
    self.photosView.photosState = PYPhotosViewStateDidCompose;
    self.photosView.photoMargin = 2;
    self.photosView.photoWidth = W;
    self.photosView.photoHeight = _photosView.photoWidth;
    self.photosView.showDuration = 0.25;
    self.photosView.hiddenDuration = 0.25;
    self.photosView.x = (self.view.width - (W * 3 - self.photosView.photoMargin*2))/2;
    self.photosView.y = CGRectGetMaxY(self.descTextView.frame) + 15;
    [self.view addSubview:self.photosView];
    
    // 底部三按钮
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    if (userModel.type == 1 || userModel.type == 2) {
        // 有管理权限
        NSArray *titleArr = @[@"转发统计",@"一键转发",@"提醒转发"];
        CGFloat space = 10;
        CGFloat W = (SCREEN_WIDTH - space*(titleArr.count + 1))/titleArr.count;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((i%titleArr.count) * (W + space) + space, self.view.height - 40 - 30 - 64, W, 44);
            button.backgroundColor = MainColor;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3;
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.tag = i+1;
            if (i == 0) {
                // 转发统计
                
            }else if (i == 1){
                // 发送到朋友圈
                [button addTarget:self action:@selector(shareToWechatAction) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (i == 2){
                // 转发提醒
                [button addTarget:self action:@selector(sendTipsToMemberAction) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:button];
        }
    }else{
        // 没有管理权限，一个转发按钮
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = MainColor;
        [sendButton setTitle:@"一键转发" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(shareToWechatAction) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setFrame:CGRectMake(30, self.view.height - 40 - 30 - 64, self.view.width - 60, 44)];
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 4;
        [self.view addSubview:sendButton];
    }
    
}

// 发送到朋友圈 SLComposeViewController
- (void)shareToWechatAction
{
    
    BOOL isAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeWechat];
    if (isAvailable == NO) {
        [MBProgressHUD showError:@"应用不支持当前平台分享"];
        return;
    }
    
    [self tipAction];
    
    UIPasteboard *pasted = [UIPasteboard generalPasteboard];
    [pasted setString:self.mobanModel.template_content];
    [MBProgressHUD showSuccess:@"已复制到剪贴板"];
    
    NSArray<PYPhoto *> *photoArray = self.photosView.photos;
    
    // 创建分享控制器
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeWechat];
    
    for (int i = 0; i < photoArray.count; i++) {
        PYPhoto *photo = photoArray[i];
        UIImage *image = photo.thumbnailImage;
        [composeVc addImage:image];
    }
    
    
    [self presentViewController:composeVc animated:YES completion:^{
        
    }];
    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
        if (reulst == SLComposeViewControllerResultDone) {
            [MBProgressHUD showSuccess:@"分享成功"];
        } else {
            [MBProgressHUD showError:@"分析失败"];
        }
    };
    
    
}


// 发送到朋友圈 UIActivityViewController
- (void)SendToWechatAction
{
    [self tipAction];
    
    
    
    UIPasteboard *pasted = [UIPasteboard generalPasteboard];
    [pasted setString:self.mobanModel.template_content];
    [MBProgressHUD showSuccess:@"已复制到剪贴板"];
    
    NSArray<PYPhoto *> *photoArray = self.photosView.photos;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < photoArray.count; i++) {
        PYPhoto *photo = photoArray[i];
        UIImage *image = photo.thumbnailImage;
        [imageArray addObject:image];
    }
    
    UIActivity *activity = [[UIActivity alloc]init];
    [activity prepareWithActivityItems:imageArray];
    [activity canPerformWithActivityItems:imageArray];
    NSArray *activityArray = @[activity];
    
    UIActivityViewController *actity = [[UIActivityViewController alloc]initWithActivityItems:imageArray applicationActivities:activityArray];
    actity.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToTencentWeibo,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypePostToWeibo,UIActivityTypePostToTwitter,UIActivityTypePostToFacebook];
    actity.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            if (activityError) {
                [self sendAlertAction:activityError.localizedDescription];
            }else{
                // 转发已完成
                
            }
        }else{
            [MBProgressHUD showError:@"转发未完成"];
        }
        
    };
    [self presentViewController:actity animated:YES completion:^{
        
    }];
    
}
// 转发提醒
- (void)sendTipsToMemberAction
{
    [MBProgressHUD showMessage:nil];
    [[NineTableManager sharedManager].netManager warnMemberWithModel:self.mobanModel Success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"提醒成功"];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
}
// 提示
- (void)tipAction
{
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithTitle:nil message:@"由于iOS系统的限制性，您在转发到微信朋友圈、QQ空间或其他社交APP之前必须手动复制文字到文本框。"];
    popTipView.shouldEnforceCustomViewPadding = YES;
    popTipView.backgroundColor = RGBACOLOR(25, 35, 45, 1);
    popTipView.animation = CMPopTipAnimationPop;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:NO atTimeInterval:30];
    popTipView.textColor = [UIColor whiteColor];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}


@end
