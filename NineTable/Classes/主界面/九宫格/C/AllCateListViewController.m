//
//  AllCateListViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AllCateListViewController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "CateMobanController.h"


@interface AllCateListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) HomeDataModel *homeModel;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation AllCateListViewController

- (instancetype)initWithModel:(HomeDataModel *)homeModel
{
    self = [super init];
    if (self) {
        self.homeModel = homeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataAction];
    }];
    
    [self getDataAction];
}
- (void)getDataAction
{
    
    [[NineTableManager sharedManager].netManager getHomeDataSuccess:^(HomeDataModel *homeModel) {
        self.homeModel = homeModel;
        [self.tableView.mj_header endRefreshing];
        [self hideMessageAction];
        [self.tableView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        [self showEmptyViewWithMessage:errorMsg];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeModel.category.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MobanClassModel *model = self.homeModel.category[indexPath.row];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = model.name;
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.lcon] placeholderImage:[UIImage imageNamed:@"class_2"]];
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@60);
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MobanClassModel *model = self.homeModel.category[indexPath.row];
    // 查看分类详情
    CateMobanController *cateMoban = [[CateMobanController alloc]initWithModel:model];
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.ReloadCareListBlock) {
        _ReloadCareListBlock(self.homeModel);
    }
}


@end
