//
//  NormalTableViewCell.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NormalTableViewCell.h"
#import <Masonry.h>

@implementation NormalTableViewCell

+ (instancetype)sharedNormalCell:(UITableView *)tableView
{
    static NSString *ID = @"NormalTableViewCell";
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:HWRandomColor]];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@36);
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
}



@end
