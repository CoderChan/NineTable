//
//  AddCareCateController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/6.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddCareCateController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>
#import "EditCareTableViewCell.h"
#import <MJRefresh/MJRefresh.h>


@interface AddCareCateController ()<UITableViewDelegate,UITableViewDataSource,EditCareCellDelegate>

// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation AddCareCateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加关注";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    //[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        [[NineTableManager sharedManager].netManager editCareListSuccess:^(NSArray *array) {
            self.tableView.hidden = NO;
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            self.tableView.hidden = YES;
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
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
    MobanClassModel *model = self.array[indexPath.row];
    model.index = indexPath.row;
    EditCareTableViewCell *cell = [EditCareTableViewCell sharedEditCareCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

#pragma mark - 编辑关注的代理
- (void)editCareCellWithModel:(MobanClassModel *)model
{
    if (model.satus) {
        // [MBProgressHUD showError:@"取消关注"];
        [[NineTableManager sharedManager].netManager cancleCareWithModel:model Success:^{
            model.satus = NO;
            [self.array replaceObjectAtIndex:model.index withObject:model];
            [self.tableView reloadData];
            if (self.ReloadDataBlock) {
                _ReloadDataBlock();
            }
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
        
    }else{
        // [MBProgressHUD showError:@"添加关注"];
        [[NineTableManager sharedManager].netManager addCareWithModel:model Success:^{
            model.satus = YES;
            [self.array replaceObjectAtIndex:model.index withObject:model];
            [self.tableView reloadData];
            if (self.ReloadDataBlock) {
                _ReloadDataBlock();
            }
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
