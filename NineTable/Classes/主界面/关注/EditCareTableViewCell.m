//
//  EditCareTableViewCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "EditCareTableViewCell.h"
#import <Masonry.h>

@interface EditCareTableViewCell ()

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;


@end

@implementation EditCareTableViewCell

+ (instancetype)sharedEditCareCell:(UITableView *)tableView
{
    static NSString *ID = @"EditCareTableViewCell";
    EditCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
       cell = [[EditCareTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MobanClassModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.lcon] placeholderImage:[UIImage imageNamed:@"class_1"]];
    self.titleLabel.text = model.name;
    NSLog(@"关注状态：%d",model.satus);
    if (model.satus) {
        // 已关注，取消关注
        [self.editButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.editButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.editButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.editButton.layer.borderWidth = 1;
        
    }else{
        // 没有关注，添加关注
        [self.editButton setTitle:@"添加关注" forState:UIControlStateNormal];
        [self.editButton setTitleColor:MainColor forState:UIControlStateNormal];
        self.editButton.layer.borderColor = MainColor.CGColor;
        self.editButton.layer.borderWidth = 1;
    }
}

- (void)setupSubViews
{
    __weak EditCareTableViewCell *copySelf = self;
    
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

    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.cornerRadius = 4;
    [self.editButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if ([copySelf.delegate respondsToSelector:@selector(editCareCellWithModel:)]) {
            [copySelf.delegate editCareCellWithModel:copySelf.model];
        }
    }];
    self.editButton.layer.borderColor = MainColor.CGColor;
    self.editButton.layer.borderWidth = 1.f;
    [self.editButton setTitle:@"编  辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:MainColor forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@65);
        make.height.equalTo(@40);
    }];
}

@end
