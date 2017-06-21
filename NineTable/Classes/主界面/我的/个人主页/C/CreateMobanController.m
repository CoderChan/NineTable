//
//  CreateMobanController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CreateMobanController.h"
#import "PYPhotoBrowser.h"
#import <LCActionSheet.h>
#import "TZImagePickerController.h"
#import "GroupTableViewCell.h"
#import "ManagerTeamController.h"

@interface CreateMobanController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TZImagePickerControllerDelegate,PYPhotosViewDelegate>

@property (strong,nonatomic) UserInfoModel *userModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源、步骤 */
@property (copy,nonatomic) NSArray *array;

/** 模板名称 */
@property (strong,nonatomic) UITextField *nameField;
/** 是否共享到团队 */
@property (strong,nonatomic) UISwitch *swithV;

/** 模板分类 */
@property (strong,nonatomic) UILabel *cateNameLabel;
// 模板分类，团队时用到
@property (strong,nonatomic) MobanClassModel *cateModel;

/** 模板内容输入框 */
@property (strong,nonatomic) YYTextView *descTextView;

/** 九宫格 */
@property (strong,nonatomic) PYPhotosView *publishPhotosView;

@end

@implementation CreateMobanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建模板";
    [self setupSubViews];
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    //[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    self.userModel = [[UserInfoManager sharedManager] getUserInfo];
    if ([self.userModel.tid intValue] == 0) {
        // 不是团队
        self.array = @[@[@"模板名称"],@[@"模板文字内容"],@[@"选择图片"]];
    }else{
        // 团队
        self.array = @[@[@"模板名称"],@[@"共享到团队",@"模板分类"],@[@"模板文字内容"],@[@"选择图片"]];
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
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
    if ([self.userModel.tid intValue] == 0) {
        // 不是团队
        UITableViewCell *cell = [self setupNoTeamCellWithTableView:tableView IndexPath:indexPath];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return cell;
        
    }else{
        // 团队
        UITableViewCell *cell = [self setupTeamCellWithTableView:tableView IndexPath:indexPath];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return cell;
    }
    
}
// 团队的cell
- (UITableViewCell *)setupTeamCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 团队名称
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.backView addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 共享到团队
            GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            [cell.backView addSubview:self.swithV];
            return cell;
        }else{
            // 模板分类
            GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            self.cateNameLabel.text = self.cateModel.name;
            [cell.backView addSubview:self.cateNameLabel];
            return cell;
        }
    }else if (indexPath.section == 2){
        // 文字内容
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        [cell.titleLabel removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.backView addSubview:self.descTextView];
        return cell;
    }else {
        // 选择照片
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.contentView addSubview:self.publishPhotosView];
        return cell;
    }
}
// 不是团队的cell
- (UITableViewCell *)setupNoTeamCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 团队名称
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.backView addSubview:self.nameField];
        return cell;
    }else if (indexPath.section == 1){
        // 文字内容
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        [cell.titleLabel removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.backView addSubview:self.descTextView];
        return cell;
    }else {
        // 选择照片
        GroupTableViewCell *cell = [GroupTableViewCell sharedGroupTableCell:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.contentView addSubview:self.publishPhotosView];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if ([self.userModel.tid intValue] != 0) {
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                
                ManagerTeamController *selectCate = [[ManagerTeamController alloc]init];
                selectCate.SelectCateBlock = ^(MobanClassModel *cateModel) {
                    self.cateModel = cateModel;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:selectCate animated:YES];
            }
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userModel.tid intValue] == 0) {
        // 不是团队
        if (indexPath.section == 0) {
            // 模板名称
            return 60;
        }else if (indexPath.section == 1){
            // 模板文字内容
            return 120;
        }else{
            // 选择图片
            return 80*3 + 40;
        }
    }else{
        // 团队
        if (indexPath.section == 0) {
            // 模板名称
            return 60;
        }else if (indexPath.section == 1){
            // 团队相关
            return 60;
        }else if (indexPath.section == 2){
            // 模板文字内容
            return 120;
        }else{
            // 选择图片
            return 80*3 + 40;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

#pragma mark - 其他方法

- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doneAction
{
    [self.view endEditing:YES];
    if ([self.userModel.tid intValue]== 0) {
        // 不是团队
        if (self.nameField.text.length < 1) {
            [self showPopTipsWithMessage:@"请输入" AtView:self.nameField inView:self.view];
            return;
        }
        if (self.descTextView.text.length < 1) {
            [self showPopTipsWithMessage:@"请输入" AtView:self.descTextView inView:self.view];
            return;
        }
        NSArray *imageArray = self.publishPhotosView.images;
        if (imageArray.count == 0) {
            [self showPopTipsWithMessage:@"请选择图片" AtView:self.publishPhotosView inView:self.view];
            return;
        }
        
        CreateMobanModel *model = [[CreateMobanModel alloc]init];
        model.mobanName = self.nameField.text;
        model.mobanDesc = self.descTextView.text;
        model.isShare = NO;
        model.team_id = @"0";
        model.cid = nil;
        [model.images addObjectsFromArray:imageArray];
        
        [MBProgressHUD showMessage:@"上传中···"];
        [[NineTableManager sharedManager].netManager createMobanWithModel:model Success:^{
            [MBProgressHUD hideHUD];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
        
    }else{
        // 团队
        if (self.nameField.text.length < 1) {
            [self showPopTipsWithMessage:@"请输入" AtView:self.nameField inView:self.view];
            return;
        }
        if (self.descTextView.text.length < 1) {
            [self showPopTipsWithMessage:@"请输入" AtView:self.descTextView inView:self.view];
            return;
        }
        if (self.cateNameLabel.text.length < 1) {
            [self showPopTipsWithMessage:@"请选择分类" AtView:self.cateNameLabel inView:self.view];
            return;
        }
        NSArray *imageArray = self.publishPhotosView.images;
        if (imageArray.count == 0) {
            [self showPopTipsWithMessage:@"请选择图片" AtView:self.publishPhotosView inView:self.view];
            return;
        }
        
        CreateMobanModel *model = [[CreateMobanModel alloc]init];
        model.mobanName = self.nameField.text;
        model.mobanDesc = self.descTextView.text;
        model.isShare = self.swithV.on;
        model.cid = self.cateModel.cid;
        model.team_id = [[UserInfoManager sharedManager] getUserInfo].tid;
        [model.images addObjectsFromArray:imageArray];
        
        [MBProgressHUD showMessage:@"上传中···"];
        [[NineTableManager sharedManager].netManager createMobanWithModel:model Success:^{
            [MBProgressHUD hideHUD];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }
}

#pragma mark - 选择图片的代理
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            // 之前和现在的
            NSMutableArray *photosArray = [NSMutableArray array];
            for (UIImage *image in images) {
                [photosArray addObject:image];
            }
            for (UIImage *image in photos) {
                [photosArray addObject:image];
            }
            [self.publishPhotosView reloadDataWithImages:photosArray];
        }
    };
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    KGLog(@"进入预览图片");
}


#pragma mark - 懒加载
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width - 16) * 0.3 - 13, 10, (self.view.width - 16)*0.7, 40)];
        _nameField.backgroundColor = [UIColor clearColor];
        _nameField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _nameField.rightViewMode = UITextFieldViewModeAlways;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.textAlignment = NSTextAlignmentRight;
        _nameField.placeholder = @"如：每日一格";
    }
    return _nameField;
}
- (UISwitch *)swithV
{
    if (!_swithV) {
        _swithV = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 16 - 20 - 44, 13, 44, 40)];
        _swithV.on = YES;
        _swithV.onTintColor = MainColor;
        [_swithV setOn:YES animated:YES];
        [_swithV addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
            
        }];
    }
    return _swithV;
}
- (YYTextView *)descTextView
{
    if (!_descTextView) {
        _descTextView = [[YYTextView alloc]initWithFrame:CGRectMake(7, 15, (self.view.width - 16) - 14, 100)];
        _descTextView.placeholderText = @"此内容将作为朋友圈的文字内容";
        _descTextView.placeholderFont = [UIFont systemFontOfSize:14];
        _descTextView.font = [UIFont systemFontOfSize:16] ;
        _descTextView.placeholderTextColor = [UIColor grayColor];
        _descTextView.backgroundColor = [UIColor clearColor];
    }
    return _descTextView;
}
- (UILabel *)cateNameLabel
{
    if (!_cateNameLabel) {
        _cateNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 16 - 20 - self.view.width*0.5, 10, self.view.width*0.5, 40)];
        _cateNameLabel.textAlignment = NSTextAlignmentRight;
        _cateNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _cateNameLabel;
}
- (PYPhotosView *)publishPhotosView
{
    if (!_publishPhotosView) {
        _publishPhotosView = [PYPhotosView photosView];
        _publishPhotosView.x = (SCREEN_WIDTH - PYPhotoWidth * PYPhotosMaxCol - PYPhotoMargin * (PYPhotosMaxCol + 1))/2;
        _publishPhotosView.y = PYPhotoMargin * 2;
        _publishPhotosView.images = @[].mutableCopy;
        _publishPhotosView.delegate = self;
    }
    return _publishPhotosView;
}


@end
