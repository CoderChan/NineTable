//
//  TransMsgViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TransMsgViewController.h"
#import "SystermMsgTableCell.h"
#import <MJRefresh.h>
#import "MobanDetialController.h"
#import "NormalTableViewCell.h"


@interface TransMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation TransMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转发提醒";
    [self setupSubViews];
}


- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NineTableManager sharedManager].netManager reSendWarnListSuccess:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            [self hideMessageAction];
            self.array = array;
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
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
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    ResendWarnModel *model = self.array[indexPath.row];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    cell.textLabel.text = [NSString stringWithFormat:@"转发模板：%@",model.tid];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResendWarnModel *model = self.array[indexPath.row];
    MobanDetialController *detial = [[MobanDetialController alloc]initWithMobanID:model];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}


@end
