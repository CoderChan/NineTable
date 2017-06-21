//
//  PhoneViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PhoneViewController.h"
#import <Masonry.h>


@interface PhoneViewController ()<UITextFieldDelegate>

{
    UIButton *commitBtn;
}

@property (copy,nonatomic) NSString *phoneStr;


@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *phoneLabel;
@property (strong,nonatomic) UILabel *descLabel;


@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号码";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    UserInfoModel *model = [[NineTableManager sharedManager].userManager getUserInfo];
    self.phoneStr = model.phone;
    
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked_phone"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(138*CKproportion);
        make.width.and.height.equalTo(@160);
    }];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *kkk = [[userDefault objectForKey:@"userPhone"] description];
    if (kkk.length == 11) {
        self.phoneStr = kkk;
    }
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.text = self.phoneStr;
    self.phoneLabel.font = [UIFont boldSystemFontOfSize:25];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.height.equalTo(@24);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.text = @"手机号码暂不支持修改";
    self.descLabel.font = [UIFont systemFontOfSize:16];
    self.descLabel.textColor = RGBACOLOR(78, 78, 78, 1);
    self.descLabel.numberOfLines = 0;
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(14);
        make.height.equalTo(@44);
    }];
    
    
    
}

@end
