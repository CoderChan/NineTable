//
//  SearchFieldView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchFieldView.h"



@interface SearchFieldView ()<UITextFieldDelegate>

/** 输入框 */
@property (strong,nonatomic) UITextField *textField;

@end

@implementation SearchFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    // 底部视图
    UIView *bottomView = [[UIView alloc]initWithFrame:self.bounds];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.userInteractionEnabled = YES;
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 17.5;
    [self addSubview:bottomView];
    
    // 输入框
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, bottomView.height)];
    leftView.backgroundColor = [UIColor whiteColor];
    UIImageView *leftImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search"]];
    leftImgV.frame = CGRectMake(5, 7.5, 20, 20);
    [leftView addSubview:leftImgV];
    
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, bottomView.width - 20, bottomView.height)];
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.placeholder = @"搜索";
    self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [bottomView addSubview:self.textField];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        return NO;
    }
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        return;
    }
    if (textField.text.length == 0) {
        return;
    }
    if (self.SearchResultBlock) {
        _SearchResultBlock(textField.text);
        self.textField.text = nil;
    }
}




@end
