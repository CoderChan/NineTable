//
//  UserInfoViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "UserInfoViewController.h"
#import <LCActionSheet.h>
#import "XLPhotoBrowser.h"
#import "NickNameViewController.h"
#import "PhoneViewController.h"
#import "NormalTableViewCell.h"


@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,LCActionSheetDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 我的头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 性别 */
@property (strong,nonatomic) UILabel *sexLabel;
/** 号码 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 数据源 */
@property (strong,nonatomic) UserInfoModel *userModel;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.userModel = [[UserInfoManager sharedManager] getUserInfo];
    
    self.array = @[@[@"头像"],@[@"昵称",@"性别"],@[@"手机号码"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - 表格相关
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
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.contentView addSubview:self.headImgView];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 昵称
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.nameLabel];
            return cell;
        } else {
            // 性别
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            [cell.iconView removeFromSuperview];
            [cell.titleLabel removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.sexLabel];
            return cell;
        }
    }else{
        // 手机号码
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.contentView addSubview:self.phoneLabel];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 头像
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet show];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 昵称
            NickNameViewController *name = [[NickNameViewController alloc]init];
            [self.navigationController pushViewController:name animated:YES];
        } else {
            // 性别
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"修改性别" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }
                NSString *sex;
                if (buttonIndex == 1) {
                    sex = @"男";
                }else if (buttonIndex == 2){
                    sex = @"女";
                }
                
                UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
                if ([userModel.sex isEqualToString:sex]) {
                    return;
                }
                
                [[NineTableManager sharedManager].netManager updateSex:sex Success:^{
                    self.sexLabel.text = sex;
                } Fail:^(NSString *errorMsg) {
                    [self sendAlertAction:errorMsg];
                }];
            } otherButtonTitleArray:@[@"男",@"女"]];
            [sheet show];
            
        }
    }else {
        PhoneViewController *phone = [[PhoneViewController alloc]init];
        [self.navigationController pushViewController:phone animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}

#pragma mark - 上传头像
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            // 拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.modalPresentationStyle= UIModalPresentationPageSheet;
                imagePickerController.modalTransitionStyle = UIModalPresentationPageSheet;
                [self presentViewController:imagePickerController animated:YES completion:^{
                }];
                
            }
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
            [imagepicker.navigationBar setBarTintColor:NavColor];
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
    
    UIImage * orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
        [MBProgressHUD showMessage:nil];
        [[NineTableManager sharedManager].netManager uploadHeadWithImage:orgImage Progress:^(NSProgress *progress) {
            
        } Success:^(NSString *headUrl) {
            [MBProgressHUD hideHUD];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }else {
        [MBProgressHUD showError:@"不支持的图片类型"];
    }
    
}
// 取消上传
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = [[UserInfoManager sharedManager] getUserInfo];
    self.nameLabel.text = self.userModel.nick_name;
    self.phoneLabel.text = self.userModel.phone;
}

- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 30*CKproportion, 10, 60, 60)];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.header_img] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.userInteractionEnabled = YES;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [XLPhotoBrowser showPhotoBrowserWithImages:@[self.headImgView.image] currentImageIndex:0];
        }];
        [_headImgView addGestureRecognizer:tap];
    }
    return _headImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 30*CKproportion, 10, 120, 30)];
        _nameLabel.text = self.userModel.nick_name;
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}
- (UILabel *)sexLabel
{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 30*CKproportion, 10, 40, 30)];
        _sexLabel.text = self.userModel.sex;
        _sexLabel.textAlignment = NSTextAlignmentRight;
        _sexLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _sexLabel;
}
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150 - 30*CKproportion, 10, 150, 30)];
        _phoneLabel.text = self.userModel.phone;
        _phoneLabel.textAlignment = NSTextAlignmentRight;
        _phoneLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _phoneLabel;
}


@end
