//
//  VIPHeadView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VIPHeadView.h"


@interface VIPHeadView ()

@property (strong,nonatomic) UIImageView *headImgView;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation VIPHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setUserModel:(UserInfoModel *)userModel
{
    _userModel = userModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.header_img] placeholderImage:[UIImage imageNamed:@"user_place"]];
    self.nameLabel.text = userModel.nick_name;
    if ([userModel.tid intValue] == 0) {
        // 个人普通用户
        _timeLabel.text = @"暂未开通VIP";
    }else{
        // 团队用户
        _timeLabel.text = [NSString stringWithFormat:@"截止日期：%@",userModel.end_time];
        _timeLabel.textColor = RGBACOLOR(253, 179, 20, 1);
        _nameLabel.textColor = RGBACOLOR(253, 179, 20, 1);
    }
}

- (void)setupSubViews
{
    // 高度120
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 60, 60)];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 30;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [_headImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    _headImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.headImgView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 18, 38, 200, 22)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame), SCREEN_WIDTH - self.nameLabel.x, 21)];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.timeLabel];
}

@end
