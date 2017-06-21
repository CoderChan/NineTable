//
//  LoginViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/5/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootTabbarController.h"


@interface LoginViewController ()<UITextFieldDelegate>

/** 用户名输入框 */
@property (strong,nonatomic) UITextField *nameField;
/** 密码输入框 */
@property (strong,nonatomic) UITextField *passField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 账号输入框
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 25, self.view.width - 30, 45)];
    self.nameField.delegate = self;
    self.nameField.backgroundColor = RGBACOLOR(217, 217, 217, 1);
    self.nameField.placeholder = @"手机号";
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.nameField.height)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.nameField];
    
    // 密码输入框
    self.passField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameField.frame) + 20, self.view.width - 30, self.nameField.height)];
    self.passField.delegate = self;
    self.passField.backgroundColor = RGBACOLOR(217, 217, 217, 1);
    self.passField.placeholder = @"密码";
    self.passField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.passField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.nameField.height)];
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    self.passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.passField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.passField];
    
//    // 忘记密码
//    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [forgetPassBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
//    [forgetPassBtn setTitleColor:MainColor forState:UIControlStateNormal];
//    forgetPassBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [forgetPassBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        
//    }];
//    forgetPassBtn.frame = CGRectMake(self.view.width - 15 - 75, CGRectGetMaxY(self.passField.frame) + 11, 75, 21);
//    [self.view addSubview:forgetPassBtn];
    
    // 注册按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    // 立即登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = MainColor;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginButton.frame = CGRectMake(40, CGRectGetMaxY(self.passField.frame)+100, self.view.width - 80, 44);
    [self.view addSubview:loginButton];
    
#ifdef DEBUG // 处于开发阶段
    self.nameField.text = @"13522705114";
    self.passField.text = @"999999";
#else // 处于发布阶段
    self.nameField.text = @"";
    self.passField.text = @"";
#endif
    
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

- (void)registerAction
{
    [self.view endEditing:YES];
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginAction
{
    [self.view endEditing:YES];
    if (![self.nameField.text isPhoneNum]) {
        [self showPopTipsWithMessage:@"号码有误" AtView:self.nameField inView:self.view];
        return;
    }
    if (self.passField.text.length < 6) {
        [self showPopTipsWithMessage:@"密码最少6位" AtView:self.passField inView:self.view];
        return;
    }
    [MBProgressHUD showMessage:@""];
    [[NineTableManager sharedManager].netManager loginWithPhone:self.nameField.text Pass:self.passField.text Success:^{
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
}

- (void)registerSuccess
{
    //     去tabbar
    RootTabbarController *tabbar = [[RootTabbarController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    window.rootViewController = tabbar;
    [window makeKeyAndVisible];
}


@end
