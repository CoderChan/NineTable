//
//  TeamMemberTableCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TeamMemberTableCell.h"
#import <Masonry.h>


@interface TeamMemberTableCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 成员名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 电话 */
@property (strong,nonatomic) UILabel *phoneLabel;


@end

@implementation TeamMemberTableCell

+ (instancetype)sharedNormalCell:(UITableView *)tableView
{
    static NSString *ID = @"TeamMemberTableCell";
    TeamMemberTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TeamMemberTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(TeamMemberModel *)model
{
    _model = model;
    _nameLabel.text = model.uname;
    _phoneLabel.text = model.phone;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.header_img] placeholderImage:[UIImage imageNamed:@"user_place"]];
}
- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 30;
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [_iconView setContentScaleFactor:[UIScreen mainScreen].scale];
    _iconView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@60);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.nameLabel.textColor = TitleColor;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY).offset(-6);
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.height.equalTo(@25);
    }];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.phoneLabel.font = [UIFont systemFontOfSize:16];
    self.phoneLabel.textColor = RGBACOLOR(65, 65, 65, 1);
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    
}


@end
