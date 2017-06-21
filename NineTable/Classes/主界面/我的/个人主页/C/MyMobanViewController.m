//
//  MyMobanViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyMobanViewController.h"
#import "CreateMobanController.h"
#import "RootNavgationController.h"
#import "CMPopTipView.h"
#import "MyMobanTableCell.h"
#import "MobanDetialController.h"
#import <MJRefresh/MJRefresh.h>


@interface MyMobanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation MyMobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的模板";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createMobanAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NineTableManager sharedManager].netManager myCreateMobanListSuccess:^(NSArray *array) {
            self.array = array;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self tipActionWithMessage:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    MobanInfoModel *model = self.array[indexPath.row];
    MyMobanTableCell *cell = [MyMobanTableCell sharedMyMobanCell:tableView];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 查看分类详情
    MobanInfoModel *model = self.array[indexPath.row];
    MobanDetialController *cateMoban = [[MobanDetialController alloc]initWithModel:model];
    [self.navigationController pushViewController:cateMoban animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [UIView new];
    head.backgroundColor = [UIColor clearColor];
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (void)tipActionWithMessage:(NSString *)message
{
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithTitle:nil message:message];
    popTipView.shouldEnforceCustomViewPadding = YES;
    popTipView.backgroundColor = RGBACOLOR(25, 35, 45, 1);
    popTipView.animation = CMPopTipAnimationPop;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3];
    popTipView.textColor = [UIColor whiteColor];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}


- (void)createMobanAction
{
    CreateMobanController *create = [CreateMobanController new];
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:create];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


@end
