//
//  NineTableCollectionCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NineTableCollectionCell.h"

#define Space 6
@interface NineTableCollectionCell ()

@property (strong,nonatomic) UIImageView *coverImgView;

@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation NineTableCollectionCell

+ (instancetype)sharedCell:(UICollectionView *)collectionView Path:(NSIndexPath *)indexPath
{
    static NSString *ID = @"NineTableCollectionCell";
    NineTableCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NineTableCollectionCell alloc]init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setMobanModel:(MobanInfoModel *)mobanModel
{
    _mobanModel = mobanModel;
    [_coverImgView sd_setImageWithURL:[NSURL URLWithString:mobanModel.thumb] placeholderImage:[UIImage imageNamed:@"home_top_bg"]];
    _nameLabel.text = mobanModel.template_name;
}
- (void)setupSubViews
{
    CGFloat width = (SCREEN_WIDTH - 4*Space)/3;
    
    // 模板缩略图
    self.backgroundColor = [UIColor whiteColor];
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    self.coverImgView.layer.masksToBounds = YES;
    self.coverImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.coverImgView.layer.borderWidth = 0.6f;
    self.coverImgView.backgroundColor = self.backgroundColor;
    [self.contentView addSubview:self.coverImgView];
    
    // 模板昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, width, width, 30)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
}


@end
