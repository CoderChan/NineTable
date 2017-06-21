//
//  CareViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CareViewController.h"
#import "EditCareTableViewCell.h"
#import "RootNavgationController.h"
#import "AddCareCateController.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "CateMobanController.h"
#import "CMPopTipView.h"

@interface CareViewController ()<UITableViewDelegate,UITableViewDataSource>

// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (copy,nonatomic) NSArray *array;

@end

@implementation CareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCareCateAction)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NineTableManager sharedManager].netManager getCareListInfoSuccess:^(NSArray *array) {
            
            [self.tableView.mj_header endRefreshing];
            self.array = array;
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            self.array = @[];
            [self.tableView reloadData];
            [self tipActionWithMessage:errorMsg];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addCareCateAction
{
    AddCareCateController *add = [AddCareCateController new];
    add.ReloadDataBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:add];
    [self presentViewController:nav animated:YES completion:nil];
    
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
    EditCareTableViewCell *cell = [EditCareTableViewCell sharedEditCareCell:tableView];
    MobanClassModel *model = self.array[indexPath.row];
    cell.model = model;
    cell.editButton.hidden = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 查看分类详情
    MobanClassModel *classModel = self.array[indexPath.row];
    CateMobanController *cateMoban = [[CateMobanController alloc]initWithModel:classModel];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:NO];
    if (![AccountTool account]) {
        self.array = @[];
        [self.tableView reloadData];
    }
}



@end
