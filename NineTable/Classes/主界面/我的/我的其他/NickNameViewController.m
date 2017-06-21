//
//  NickNameViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NickNameViewController.h"
#import "NormalTableViewCell.h"

@interface NickNameViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITextField *textField;

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self setupSubViews];
}


- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50 - 15 - 50)];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = footView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [footView addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishAction)];
    
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.titleLabel removeFromSuperview];
    [cell.iconView removeFromSuperview];
    [cell.contentView addSubview:self.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


- (UITextField *)textField
{
    if (!_textField) {
        UserInfoModel *model = [[UserInfoManager sharedManager] getUserInfo];
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, self.view.width - 30, 40)];
        _textField.text = model.nick_name;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = model.nick_name;
        _textField.font = [UIFont systemFontOfSize:16];
    }
    return _textField;
}

#pragma mark - 代理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return YES;
}

- (void)finishAction
{
    [self.view endEditing:YES];
    [[NineTableManager sharedManager].netManager updateName:self.textField.text Success:^{
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
    }];
}

@end
