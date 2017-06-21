//
//  WoViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WoViewController.h"
#import "NormalTableViewCell.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoViewController.h"
#import "SetCenterViewController.h"
#import "MyVIPViewController.h"
#import "MyMobanViewController.h"
#import "ChangePassViewController.h"


@interface WoViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 用户身份 */
@property (strong,nonatomic) UILabel *typeLabel;

/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;

@end

@implementation WoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    self.array = @[@[@"头像"],@[@"我的模板",@"我的VIP"],@[@"修改密码",@"设置"]];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        // 头像
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        [cell.contentView addSubview:self.headImgView];
        [cell.contentView addSubview:self.nameLabel];
        [cell.contentView addSubview:self.typeLabel];
        if (![AccountTool account]) {
            self.nameLabel.text = @"未登录";
            self.headImgView.image = [UIImage imageNamed:@"user_place"];
        }else{
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.header_img] placeholderImage:[UIImage imageNamed:@"user_place"]];
            self.nameLabel.text = self.userModel.nick_name.length >= 1 ? self.userModel.nick_name : [NSString stringWithFormat:@"用户%@",self.userModel.uid];
        }
        
        return cell;
    }else{
        NSArray *iconArray = @[@[@"user_place"],@[@"my_moban",@"my_vip"],@[@"my_secret",@"my_set"]];
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![AccountTool account]) {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if (indexPath.section == 0) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfo animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 我的模板
            MyMobanViewController *myMoban = [[MyMobanViewController alloc]init];
            [self.navigationController pushViewController:myMoban animated:YES];
        }else{
            // 我的VIP
            MyVIPViewController *vip = [[MyVIPViewController alloc]init];
            [self.navigationController pushViewController:vip animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            // 修改密码
            ChangePassViewController *changePass = [[ChangePassViewController alloc]init];
            [self.navigationController pushViewController:changePass animated:YES];
        }else{
            // 设置
            SetCenterViewController *set = [SetCenterViewController new];
            [self.navigationController pushViewController:set animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else{
        return 60;
    }
}


- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.header_img] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 30;
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_headImgView setContentScaleFactor:[UIScreen mainScreen].scale];
        _headImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    }
    return _headImgView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10, 20 + 5, 200, 30)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), 200, 21)];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        _typeLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    }
    return _typeLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = [[NineTableManager sharedManager].userManager getUserInfo];
    [self.tableView reloadData];
    if (self.userModel.tid) {
        self.nameLabel.textColor = RGBACOLOR(253, 179, 20, 1);
    }
    
    if (![AccountTool account]) {
        self.nameLabel.textColor = [UIColor blackColor];
        self.typeLabel.hidden = YES;
        return;
    }
    
    self.typeLabel.hidden = NO;
    if (self.userModel.type == 0) {
        self.typeLabel.text = @"超级管理员";
        self.typeLabel.textColor = RGBACOLOR(253, 179, 20, 1);
    }else if (self.userModel.type == 1){
        self.typeLabel.text = @"管理员";
        self.typeLabel.textColor = RGBACOLOR(253, 179, 20, 1);
    }else if (self.userModel.type == 2){
        self.typeLabel.text = @"授权用户";
        self.typeLabel.textColor = RGBACOLOR(253, 179, 20, 1);
    }else{
        self.typeLabel.text = @"普通用户";
    }
}

@end
