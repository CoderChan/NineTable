//
//  CateIconView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CateIconView.h"


@interface CateIconView ()

// 分类图标
@property (strong,nonatomic) UIImageView *iconImgView;
// 分类名称
@property (strong,nonatomic) UILabel *cateNameLabel;

@end

@implementation CateIconView

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

- (void)setCareModel:(MobanClassModel *)careModel
{
    _careModel = careModel;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:careModel.lcon] placeholderImage:[UIImage imageNamed:@"class_place"]];
    _cateNameLabel.text = careModel.name;
}

- (void)setupSubViews
{
    CGFloat spaceH = 8 * CKproportion; // 横向间距
    CGFloat spaceZ = 15 * CKproportion; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*6)/5;  // 宽
    CGFloat H = (180*CKproportion - spaceZ*3)/2; // 高
    
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, W - 20, H - 24)];
//    self.iconImgView.layer.masksToBounds = YES;
//    self.iconImgView.layer.cornerRadius = 12;
    self.iconImgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.iconImgView];
    
    self.cateNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImgView.frame), W, 24)];
    self.cateNameLabel.font = [UIFont systemFontOfSize:11];
    self.cateNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.cateNameLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(self.careModel);
        }
    }];
    [self addGestureRecognizer:tap];
    
    
}

@end
