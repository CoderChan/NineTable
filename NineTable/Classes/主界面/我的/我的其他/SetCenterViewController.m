//
//  SetCenterViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SetCenterViewController.h"
#import "NormalTableViewCell.h"
#import <LCActionSheet.h>
#import <WXApi.h>
#import "WXApiManager.h"
#import "HTTPManager.h"
#import "NormalWebViewController.h"



@interface SetCenterViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation SetCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置中心";
    
    [WXApiManager sharedManager].delegate = self;
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = @[@"给我们评分",@"联系我们",@"推荐给朋友"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) - self.array.count * 60)];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = self.view.backgroundColor;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, footView.height - 40 - 44, self.view.width - 40, 44);
    button.backgroundColor = WarningColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"安全退出" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定退出，换号登录？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 退出登录
                [[NineTableManager sharedManager].netManager returnAccountCompletion:^{
                    self.tableView.tableFooterView = nil;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        } otherButtonTitles:@"确定退出", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }];
    [footView addSubview:button];
    
    if ([AccountTool account]) {
        self.tableView.tableFooterView = footView;
    }else{
        self.tableView.tableFooterView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // 给我们评分
        NSURL *url = [NSURL URLWithString:DownLoadURL];
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if(indexPath.row == 1){
        // 联系我们
        NormalWebViewController *web = [[NormalWebViewController alloc]initWithUrlStr:@"http://www.bjletu.com/"];
        [self.navigationController pushViewController:web animated:YES];
    }else{
        // 推荐给朋友
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self shareToWechat:0];
            }else if (buttonIndex == 2){
                [self shareToWechat:1];
            }
        } otherButtonTitles:@"微信朋友",@"朋友圈", nil];
        [sheet show];
    }
}

- (void)shareToWechat:(int)scenType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"良心推荐下载";
    message.description = @"一键转发9张图片到朋友圈的实用工具";
    [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = DownLoadURL;
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = scenType;
    [WXApi sendReq:req];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSString *authUrl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAppID,WeChatAppKey,response.code];
    [HTTPManager GET:authUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"微信授权信息 = %@",responseObject);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendAlertAction:error.localizedDescription];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


@end
