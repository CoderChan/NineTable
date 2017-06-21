//
//  GroupTableViewCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GroupTableViewCell.h"
#import <Masonry.h>

@implementation GroupTableViewCell

+ (instancetype)sharedGroupTableCell:(UITableView *)tableView
{
    static NSString *ID = @"GroupTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BackColor;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    // 背景view
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(7);
        make.top.equalTo(self.backView.mas_top).offset(15);
        make.height.equalTo(@30);
    }];
}

@end
