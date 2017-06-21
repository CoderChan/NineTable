//
//  TeamCateTableCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TeamCateTableCell.h"
#import <Masonry.h>


@interface TeamCateTableCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 分类简介 */
@property (strong,nonatomic) UILabel *descLabel;

@end

@implementation TeamCateTableCell

+ (instancetype)sharedTeamCateCell:(UITableView *)tableView
{
    static NSString *ID = @"TeamCateTableCell";
    TeamCateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TeamCateTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MobanClassModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.lcon] placeholderImage:[UIImage imageNamed:@"class_1"]];
    self.titleLabel.text = model.name;
    
}

- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_1"]];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
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
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.LongPressBlock) {
            _LongPressBlock(self.model);
        }
    }];
    [self addGestureRecognizer:longTap];

}

@end
