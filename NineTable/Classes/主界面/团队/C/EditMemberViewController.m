//
//  EditMemberViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "EditMemberViewController.h"
#import "GroupTableViewCell.h"
#import <LCActionSheet.h>
#import "CMPopTipView.h"

@interface EditMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
// 成员模型
@property (strong,nonatomic) TeamMemberModel *memberModel;
// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (copy,nonatomic) NSArray *array;
// 我的用户模型
@property (strong,nonatomic) UserInfoModel *userModel;
// 删除成员 仅限管理员
@property (strong,nonatomic) UIView *footView;

@property (strong,nonatomic) UITextField *nameField;

@property (strong,nonatomic) UILabel *sexLabel;

@property (strong,nonatomic) UITextField *phoneField;

@property (strong,nonatomic) UITextField *passField;

@end

@implementation EditMemberViewController

- (instancetype)initWithModel:(TeamMemberModel *)model
{
    self = [super init];
    if (self) {
        self.memberModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.memberModel) {
        self.title = @"编辑成员信息";
    }else{
        self.title = @"添加团队成员";
    }
    self.userModel = [[UserInfoManager sharedManager] getUserInfo];
    [self setupSubViews];
}

- (void)setupSubViews
{
    if (self.memberModel) {
        // 编辑成员信息
       self.array = @[@"姓名",@"性别",@"手机号",@"密码"];
    }else{
        // 添加成员
        self.array = @[@"姓名",@"性别",@"手机号"];
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    if (self.memberModel) {
        // 获取成员详细资料
        [[NineTableManager sharedManager].netManager memberDetialWithModel:self.memberModel Success:^(TeamMemberModel *detialModel) {
            self.memberModel = detialModel;
            self.sexLabel.text = detialModel.sex;
            self.passField.text = detialModel.enable_pwd;
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
        
        if ([self.memberModel.uid isEqualToString:[AccountTool account].userID]) {
            // 自己，不显示删除按钮
        }else{
            // 删除成员按钮
            self.tableView.tableFooterView = self.footView;
        }
    }
    
    // 编辑或添加成员信息
    if (self.userModel.type == 1 || self.userModel.type == 2) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
        
        
    }
    
}


#pragma mark - 表格相关
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
    if (indexPath.section == 0) {
        // 姓名
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        // 性别
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.sexLabel];
        return cell;
    }else if (indexPath.section == 2){
        // 手机号
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.phoneField];
        return cell;
    }else {
        // 密码
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.passField];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        // 性别
        if (self.userModel.type == 1 || self.userModel.type == 2) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }
                NSString *sex;
                if (buttonIndex == 1) {
                    sex = @"男";
                }else if (buttonIndex == 2){
                    sex = @"女";
                }
                
                self.sexLabel.text = sex;
                
            } otherButtonTitleArray:@[@"男",@"女"]];
            [sheet show];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width - 20) * 0.3, 10, (self.view.width - 20)*0.7, 40)];
        _nameField.backgroundColor = [UIColor clearColor];
        _nameField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _nameField.rightViewMode = UITextFieldViewModeAlways;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.textAlignment = NSTextAlignmentRight;
        if (self.memberModel) {
            _nameField.text = self.memberModel.uname;
        }else{
            _nameField.text = self.memberModel.uname;
        }
        if (self.userModel.type == 3) {
            _nameField.enabled = NO;
        }
        _nameField.placeholder = @"如：张三";
    }
    return _nameField;
}

- (UILabel *)sexLabel
{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width - 30) * 0.3, 10, (self.view.width - 30)*0.7, 40)];
        if (self.memberModel) {
            _sexLabel.text = self.memberModel.sex;
        }else{
            
        }
        _sexLabel.font = [UIFont systemFontOfSize:16];
        _sexLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sexLabel;
}
- (UITextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width - 20) * 0.3, 10, (self.view.width - 20)*0.7, 40)];
        _phoneField.backgroundColor = [UIColor clearColor];
        _phoneField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.rightViewMode = UITextFieldViewModeAlways;
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneField.font = [UIFont systemFontOfSize:16];
        _phoneField.textAlignment = NSTextAlignmentRight;
        if (self.memberModel) {
            _phoneField.text = self.memberModel.phone;
        }else{
            
        }
        if (self.userModel.type == 3) {
            _phoneField.enabled = NO;
        }
        _phoneField.placeholder = @"如：13522705114";
    }
    return _phoneField;
}
- (UITextField *)passField
{
    if (!_passField) {
        _passField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width - 20) * 0.3, 10, (self.view.width - 20)*0.7, 40)];
        
        _passField.backgroundColor = [UIColor clearColor];
        _passField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _passField.rightViewMode = UITextFieldViewModeAlways;
        _passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passField.font = [UIFont systemFontOfSize:16];
        _passField.textAlignment = NSTextAlignmentRight;
        if (self.memberModel) {
            _passField.text = self.memberModel.enable_pwd;
        }else{
            _passField.enabled = NO;
        }
        if (self.userModel.type == 3) {
            _passField.enabled = NO;
        }
        _passField.placeholder = @"至少6位长度";
    }
    return _passField;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _footView.backgroundColor = self.view.backgroundColor;
        _footView.userInteractionEnabled = YES;
        
#warning 授权用户按钮，没有成员type没法写
//        // 授权用户为团队管理员
//        UIButton *shouButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        shouButton.backgroundColor = WarningColor;
//        shouButton.frame = CGRectMake(20, 40, _footView.width - 40, 42);
//        shouButton.layer.masksToBounds = YES;
//        shouButton.layer.cornerRadius = 4;
//        [shouButton setTitle:@"授权为管理员" forState:UIControlStateNormal];
//        [shouButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [shouButton addTarget:self action:@selector(deleteMemberAction) forControlEvents:UIControlEventTouchUpInside];
//        [_footView addSubview:shouButton];
        
        
        // 删除成员按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = WarningColor;
        deleteButton.frame = CGRectMake(20, 40, _footView.width - 40, 42);
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.cornerRadius = 4;
        [deleteButton setTitle:@"删除成员" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteMemberAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:deleteButton];
    }
    return _footView;
}


#pragma mark - 完成
- (void)deleteMemberAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定删除成员？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NineTableManager sharedManager].netManager deleteTeamMember:self.memberModel Success:^{
                if (self.DeleteMemberBlock) {
                    _DeleteMemberBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
        }
    } otherButtonTitles:@"删除", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
    
}
- (void)doneAction
{
    [self.view endEditing:YES];
    if (self.array.count == 3) {
        // 添加成员
        if (self.nameField.text.length == 0) {
            [self showPopTipsWithMessage:@"请输入名称" AtView:self.nameField inView:self.view];
            return;
        }
        if (self.sexLabel.text.length == 0) {
            [self showPopTipsWithMessage:@"请选择性别" AtView:self.sexLabel inView:self.view];
            return;
        }
        
        if (![self.phoneField.text isPhoneNum]) {
            [self showPopTipsWithMessage:@"请输入密码" AtView:self.phoneField inView:self.view];
            return;
        }
        
        [[NineTableManager sharedManager].netManager addMemberWithModel:self.memberModel Name:self.nameField.text Sex:self.sexLabel.text Phone:self.phoneField.text Success:^{
            [self showOneAlertWithMessage:@"添加成功，将以短信通知对方。\r您也可亲自通知对方。" ConfirmClick:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }else{
        // 编辑成员信息
        if (self.nameField.text.length == 0) {
            [self showPopTipsWithMessage:@"请输入名称" AtView:self.nameField inView:self.view];
            return;
        }
        if (self.sexLabel.text.length == 0) {
            [self showPopTipsWithMessage:@"请选择性别" AtView:self.sexLabel inView:self.view];
            return;
        }
        
        if (self.phoneField.text.length == 0) {
            [self showPopTipsWithMessage:@"请输入密码" AtView:self.phoneField inView:self.view];
            return;
        }
        if (![self.phoneField.text isPhoneNum]) {
            [self showPopTipsWithMessage:@"请输入密码" AtView:self.phoneField inView:self.view];
            return;
        }
        if (self.passField.text.length < 6) {
            [self showPopTipsWithMessage:@"密码至少6位" AtView:self.passField inView:self.view];
            return;
        }
        
        self.memberModel.uname = self.nameField.text;
        self.memberModel.sex = self.sexLabel.text;
        self.memberModel.enable_pwd = self.passField.text;
        self.memberModel.phone = self.phoneField.text;
        
        [[NineTableManager sharedManager].netManager editMemberWithModel:self.memberModel Success:^{
            [self showOneAlertWithMessage:@"更新成功" ConfirmClick:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.userModel.type == 1 || self.userModel.type == 2) {
        if (!self.memberModel) {
            NSString *tips = @"添加成员后，系统将发送短信到对方手机，初始密码为随机，登录后可修改，请确保对方手机能接收短信。";
            [self tipActionWithMessage:tips];
        }
    }
    
}

- (void)tipActionWithMessage:(NSString *)message
{
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithTitle:nil message:message];
    popTipView.shouldEnforceCustomViewPadding = YES;
    popTipView.backgroundColor = RGBACOLOR(25, 35, 45, 1);
    popTipView.animation = CMPopTipAnimationPop;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:NO atTimeInterval:30];
    popTipView.textColor = [UIColor whiteColor];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}



@end
