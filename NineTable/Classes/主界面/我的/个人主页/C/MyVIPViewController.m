//
//  MyVIPViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyVIPViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "VIPTableViewCell.h"
#import "VIPHeadView.h"
#import "PayOrderView.h"
#import <WXApiObject.h>
#import "WXApiManager.h"


@interface MyVIPViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) VIPHeadView *headView;
// 支付模型
@property (strong,nonatomic) WechatPayInfoModel *payModel;

@end

@implementation MyVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的VIP";
    [self setupSubViews];
    
    [WXApiManager sharedManager].delegate = self;
    // 监听支付回调
    [YLNotificationCenter addObserver:self selector:@selector(payResultAction) name:WechatPayResultNoti object:nil];
    // 从前台进入的话
    [YLNotificationCenter addObserver:self selector:@selector(payResultAction) name:UIApplicationDidBecomeActiveNotification object:nil];
}

// 查询支付结果
- (void)payResultAction
{
    
    [[NineTableManager sharedManager].netManager payResultWithModel:self.payModel Success:^{
        
        [MBProgressHUD showSuccess:@"支付成功"];
        self.headView.userModel = [[UserInfoManager sharedManager] getUserInfo];
        
    } Fail:^(NSString *errorMsg) {
        
        [MBProgressHUD showError:@"支付失败" toView:self.view];
    }];
    
}

- (void)setupSubViews
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataAction];
    }];
    
    [self getDataAction];
}

- (void)getDataAction
{
    [[NineTableManager sharedManager].netManager vipListSuccess:^(NSArray *array) {
        [self.tableView.mj_header endRefreshing];
        [self hideMessageAction];
        self.tableView.tableHeaderView = self.headView;
        self.array = array;
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        [self showEmptyViewWithMessage:errorMsg];
        [self.tableView.mj_header endRefreshing];
    }];
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
    VIPInfoModel *model = self.array[indexPath.row];
    VIPTableViewCell *cell = [VIPTableViewCell sharedVIPCell:tableView];
    cell.PayVIPBlock = ^(VIPInfoModel *vipModel){
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        PayOrderView *payView = [[PayOrderView alloc]initWithFrame:keyWindow.bounds];
        payView.PayModelBlock = ^(WechatPayInfoModel *payModel) {
            self.payModel = payModel;
        };
        payView.vipModel = vipModel;
        [keyWindow addSubview:payView];
        
    };
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (VIPHeadView *)headView
{
    if (!_headView) {
        _headView = [[VIPHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
        _headView.userModel = [[UserInfoManager sharedManager] getUserInfo];
        
    }
    return _headView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)dealloc
{
    //移除通知
    [YLNotificationCenter removeObserver:self];
}

@end
