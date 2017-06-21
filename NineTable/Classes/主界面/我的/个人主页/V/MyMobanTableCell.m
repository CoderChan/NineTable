//
//  MyMobanTableCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MyMobanTableCell.h"
#import <Masonry.h>

@interface MyMobanTableCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 创建时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation MyMobanTableCell

+ (instancetype)sharedMyMobanCell:(UITableView *)tableView
{
    static NSString *ID = @"MyMobanTableCell";
    MyMobanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyMobanTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MobanInfoModel *)model
{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageWithColor:NavColor]];
    _titleLabel.text = model.template_name;
    _timeLabel.text = [NSString stringWithFormat:@"创建于%@",model.create_time];
}

- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:NavColor]];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@60);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.textColor = TitleColor;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.height.equalTo(@23);
    }];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.timeLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@21);
    }];
    
    
}



@end
