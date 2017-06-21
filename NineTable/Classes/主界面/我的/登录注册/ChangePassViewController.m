//
//  ChangePassViewController.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate>
{
    
    int ReGetCodeNum; // 重新获取验证码时间间隔
    dispatch_source_t _timer;
}
/** 手机号 */
@property (strong,nonatomic) UITextField *nameField;
/** 验证码 */
@property (strong,nonatomic) UITextField *codeField;
/** 密码 */
@property (strong,nonatomic) UITextField *passField;
/** 获取验证码 */
@property (strong,nonatomic) UIButton *codeButton;

@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    ReGetCodeNum = 60;
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    //__weak __block RegisterViewController *copySelf = self;
    // 账号输入框
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 25, self.view.width - 30, 45)];
    self.nameField.delegate = self;
    self.nameField.backgroundColor = RGBACOLOR(217, 217, 217, 1);
    NSString *namePlace = @"手机号";
    NSMutableAttributedString *namePlaceAtt = [[NSMutableAttributedString alloc]initWithString:namePlace attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.nameField.attributedPlaceholder = namePlaceAtt;
    self.nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.nameField.height)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.nameField];
    
    // 验证码
    self.codeField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameField.frame) + 20, (self.view.width - 30 - 20)/2 + 40, self.nameField.height)];
    self.codeField.backgroundColor = self.nameField.backgroundColor;
    self.codeField.delegate = self;
    self.codeField.placeholder = @"验证码";
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.codeField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.codeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.nameField.height)];
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.codeField];
    
    // 获取验证码
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.backgroundColor = MainColor;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.codeButton.frame = CGRectMake(CGRectGetMaxX(self.codeField.frame)+20, self.codeField.y, (self.view.width - 30 - 20)/2 - 40, self.codeField.height);
    [self.codeButton addTarget:self action:@selector(getCodeNumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.codeButton];
    
    // 密码输入框
    self.passField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.codeField.frame) + 20, self.view.width - 30, self.nameField.height)];
    self.passField.delegate = self;
    self.passField.backgroundColor = self.nameField.backgroundColor;
    self.passField.placeholder = @"密码至少6位长度";
    self.passField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.passField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.nameField.height)];
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    self.passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.passField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.passField];
    
    
    // 立即注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"确定修改" forState:UIControlStateNormal];
    registerButton.backgroundColor = MainColor;
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame = CGRectMake(40, CGRectGetMaxY(self.passField.frame)+120, self.view.width - 80, 44);
    [self.view addSubview:registerButton];
    
    
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
#pragma mark - 获取验证码
- (void)getCodeNumAction
{
    [self.view endEditing:YES];
    
    if (![self.nameField.text isPhoneNum]) {
        [self showPopTipsWithMessage:@"号码有误" AtView:self.nameField inView:self.view];
        return;
    }
    
    self.codeButton.enabled = NO;
    
    [[NineTableManager sharedManager].netManager getCodeWithPhone:self.nameField.text Success:^{
        [self openCountdown];
        [MBProgressHUD showSuccess:@"已发送至您的手机"];
        [self.codeField becomeFirstResponder];
        
        // 恢复按钮
        self.codeButton.backgroundColor = MainColor;
        [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeButton.enabled = YES;
        
    } Fail:^(NSString *errorMsg) {
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //设置按钮的样式
            self.codeButton.backgroundColor = MainColor;
            [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.codeButton.enabled = YES;
            [MBProgressHUD showError:errorMsg];
        });
    }];
}
#pragma mark - 立即注册
- (void)registerAction
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
    if (self.codeField.text.length < 4) {
        [self showPopTipsWithMessage:@"验证码不对" AtView:self.codeField inView:self.view];
        return;
    }
    [MBProgressHUD showMessage:nil];
    
    // 修改密码
    [[NineTableManager sharedManager].netManager changePassWithPhone:self.nameField.text Pass:self.passField.text Code:self.codeField.text Success:^(int code) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
    
}
#pragma mark - 其他方法
// 开启倒计时效果
- (void)openCountdown
{
    
    __block NSInteger time = ReGetCodeNum; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                self.codeButton.backgroundColor = MainColor;
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.codeButton.enabled = YES;
            });
            
        }else{
            
            int seconds = time % ReGetCodeNum;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.codeButton.backgroundColor = self.nameField.backgroundColor;
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.codeButton.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}



@end
