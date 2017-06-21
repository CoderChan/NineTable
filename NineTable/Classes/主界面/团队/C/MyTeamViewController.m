//
//  MyTeamViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyTeamViewController.h"
#import "TeamMemberTableCell.h"
#import <MJRefresh/MJRefresh.h>
#import "EditMemberViewController.h"


@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UIView *footView;


@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的团队";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NineTableManager sharedManager].netManager teamMemberListSuccess:^(NSArray *array) {
            
            self.tableView.tableFooterView = self.footView;
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            
            self.array = @[];
            [self.tableView reloadData];
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
            
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
    
    
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
    TeamMemberModel *model = self.array[indexPath.row];
    
    TeamMemberTableCell *cell = [TeamMemberTableCell sharedNormalCell:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamMemberModel *model = self.array[indexPath.row];
    EditMemberViewController *edit = [[EditMemberViewController alloc]initWithModel:model];
    edit.DeleteMemberBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:edit animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        _footView.backgroundColor = self.view.backgroundColor;
        _footView.userInteractionEnabled = YES;
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, _footView.width - 40, 70)];
        subView.backgroundColor = [UIColor clearColor];
        subView.layer.masksToBounds = YES;
        subView.layer.cornerRadius = 6;
        
        
        [_footView addSubview:subView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 23, subView.width - 40, 40)];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"添加团队成员";
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4;
        label.backgroundColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [subView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            EditMemberViewController *edit = [[EditMemberViewController alloc]initWithModel:nil];
            [self.navigationController pushViewController:edit animated:YES];
        }];
        [_footView addGestureRecognizer:tap];
    }
    return _footView;
}

/**
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel *model = [[UserInfoManager sharedManager] getUserInfo];
    if (model.type == 0 || model.type == 1) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel *model = [[UserInfoManager sharedManager] getUserInfo];
    if (model.type == 0 || model.type == 1) {
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        
        return @[action1,action2];
    }else{
        return NULL;
    }
}
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


@end
