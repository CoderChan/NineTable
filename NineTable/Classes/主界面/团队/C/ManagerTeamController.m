//
//  ManagerTeamController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ManagerTeamController.h"
#import "NormalTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "TeamCateTableCell.h"
#import "CateMobanController.h"
#import <LCActionSheet.h>

@interface ManagerTeamController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isShowActionSheet;
}
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation ManagerTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队模板";
    [self setupSubViews];
}

- (void)setupSubViews
{
    isShowActionSheet = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        [[NineTableManager sharedManager].netManager teamCateListSuccess:^(NSArray *array) {
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            self.array = @[].mutableCopy;
            [self.tableView reloadData];
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
    [self.tableView.mj_header beginRefreshing];
}
- (void)refreshTableAction
{
    [self.tableView.mj_header beginRefreshing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak TeamCateTableCell *cell = [TeamCateTableCell sharedTeamCateCell:tableView];
    cell.LongPressBlock = ^(MobanClassModel *longModel) {
        if (!isShowActionSheet) {
            [self presentMenuControllerWithModel:longModel];
        }else{
            return ;
        }
    };
    MobanClassModel *model = self.array[indexPath.section];
    model.index = indexPath.section;
    model.isAllMoBan = NO;
    cell.model = model;
    return cell;
}
// 长按cell弹出UIMenuController
- (void)presentMenuControllerWithModel:(MobanClassModel *)model
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"删除该团队分类，将删除其分类下的模板" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        isShowActionSheet = NO;
        if (buttonIndex == 1) {
            [[NineTableManager sharedManager].netManager deleteTeamCateWithModel:model Success:^{
                [self.array removeObjectAtIndex:model.index];
                [self.tableView reloadData];
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
        }
    } otherButtonTitles:@"确定删除", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObjects:@1, nil];
    [sheet show];
    isShowActionSheet = YES;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MobanClassModel *classModel = self.array[indexPath.section];
    if (self.SelectCateBlock) {
        _SelectCateBlock(classModel);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        // 查看分类详情
        CateMobanController *cateMoban = [[CateMobanController alloc]initWithModel:classModel];
        [self.navigationController pushViewController:cateMoban animated:YES];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }];
    action.backgroundColor = WarningColor;
    return @[action];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


@end
