//
//  CreateCateViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CreateCateViewController.h"
#import "GroupTableViewCell.h"
#import <LCActionSheet.h>
#import "SelectCateIconView.h"


@interface CreateCateViewController ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SelectIconDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

/** 分类名称 */
@property (strong,nonatomic) UITextField *nameField;
/** 分类说明 */
@property (strong,nonatomic) YYTextView *descTextView;

/** 分类素材图标 */
@property (copy,nonatomic) NSArray *cateMaterArray;

/** 分类图标 */
@property (assign,nonatomic) BOOL isSelectIcon;
@property (strong,nonatomic) UIImageView *iconView;

// 区分是选择的素材还是本地相册
@property (assign,nonatomic) BOOL isLocalPhoto;

/** 只有在选择素材图标时有用 */
@property (strong,nonatomic) CateMaterModel *cateIconModel;

@end

@implementation CreateCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建分类";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.isSelectIcon = NO;
    self.isLocalPhoto = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    //[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    self.array = @[@"分类名称",@"分类介绍",@"分类图标"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    [[NineTableManager sharedManager].netManager getCateMaterialSuccess:^(NSArray *array) {
        self.cateMaterArray = array;
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
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
        // 分类名称
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        // 分类介绍
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.backView addSubview:self.descTextView];
        return cell;
    }else{
        // 选择图标
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.titleLabel.text = self.array[indexPath.section];
        [cell.backView addSubview:self.iconView];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 2) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"推荐素材",@"从相册中选择", nil];
        [actionSheet show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1){
        return 150;
    }else{
        return 60;
    }
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

- (void)dismissAction
{
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doneAction
{
    [self.view endEditing:YES];
    // 如果不是团队，那就不允许创建分类
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    if ([userModel.tid intValue] == 0) {
        // 普通用户不能创建分类
        [self sendAlertAction:@"您不是团队管理员，暂不能创建团队分类。如果您想成为团队管理员，您可以前往个人界面开通VIP"];
        return;
    }
    
    if (self.nameField.text.length < 1) {
        [self showPopTipsWithMessage:@"请输入名称" AtView:self.nameField inView:self.view];
        return;
    }
    if (self.descTextView.text.length < 1) {
        [self showPopTipsWithMessage:@"请输入简介" AtView:self.descTextView inView:self.view];
        return;
    }
    if (!self.isSelectIcon) {
        [self showPopTipsWithMessage:@"请选择图标" AtView:self.iconView inView:self.view];
        return;
    }
    // 开始创建分类
    if (self.isLocalPhoto) {
        // 本地相册
        [MBProgressHUD showMessage:nil];
        [[NineTableManager sharedManager].netManager createMobanCateWithPhoto:self.iconView.image CateName:self.nameField.text Desc:self.descTextView.text Success:^{
            [MBProgressHUD hideHUD];
            if (self.ReloadBlock) {
                _ReloadBlock();
                [self dismissAction];
            }
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }else{
        // 选择的素材
        [MBProgressHUD showMessage:nil];
        [[NineTableManager sharedManager].netManager createMobanCateWithMaterl:self.cateIconModel.lcon CateName:self.nameField.text Desc:self.descTextView.text Success:^{
            [MBProgressHUD hideHUD];
            if (self.ReloadBlock) {
                _ReloadBlock();
                [self dismissAction];
            }
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }
    
    
}

#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width - 16) * 0.3, 10, (self.view.width - 16)*0.7, 40)];
        _nameField.backgroundColor = [UIColor clearColor];
        _nameField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _nameField.rightViewMode = UITextFieldViewModeAlways;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.textAlignment = NSTextAlignmentRight;
        _nameField.placeholder = @"如：智诚分享";
    }
    return _nameField;
}
- (YYTextView *)descTextView
{
    if (!_descTextView) {
        _descTextView = [[YYTextView alloc]initWithFrame:CGRectMake(7, 15, (self.view.width - 16) - 14, 120)];
        _descTextView.placeholderText = @"分类介绍";
        _descTextView.placeholderFont = [UIFont systemFontOfSize:14];
        _descTextView.font = [UIFont systemFontOfSize:16] ;
        _descTextView.placeholderTextColor = [UIColor grayColor];
        _descTextView.backgroundColor = [UIColor clearColor];
    }
    return _descTextView;
}
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width - 16) - 40 - 20, 10, 40, 40)];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [_iconView setContentScaleFactor:[UIScreen mainScreen].scale];
        _iconView.layer.masksToBounds = YES;
        _iconView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
        _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}

#pragma mark - 选择图片的代理
- (void)selectCateIconWithModel:(CateMaterModel *)cateIconModel
{
    self.isSelectIcon = YES;
    self.isLocalPhoto = NO;
    self.cateIconModel = cateIconModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.cateIconModel.lcon] placeholderImage:[UIImage imageNamed:@"class_0"]];
}
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            // 推荐素材
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            SelectCateIconView *selectIcon = [[SelectCateIconView alloc]initWithFrame:keyWindow.bounds];
            selectIcon.array = self.cateMaterArray;
            selectIcon.delegate = self;
            [keyWindow addSubview:selectIcon];
            break;
        }
        case 2:
        {
            // 从相册中选择
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            [imagepicker.navigationController.navigationBar setTranslucent:NO];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            imagepicker.modalPresentationStyle= UIModalPresentationPageSheet;
            imagepicker.modalTransitionStyle = UIModalPresentationPageSheet;
            imagepicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [imagepicker.navigationBar setBarTintColor:[UIColor clearColor]];
            [self presentViewController:imagepicker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (orgImage) {
        self.isSelectIcon = YES;
        self.isLocalPhoto = YES;
        self.iconView.image = orgImage;
    }else{
        [MBProgressHUD showError:@"暂不支持此类型的图片"];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
