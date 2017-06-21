//
//  SystermMsgTableCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SystermMsgTableCell.h"
#import <Masonry.h>


@interface SystermMsgTableCell ()

// 消息内容
@property (strong,nonatomic) UILabel *msgLabel;

@end

@implementation SystermMsgTableCell

+ (instancetype)sharedSystermCell:(UITableView *)tableView
{
    static NSString *ID = @"SystermMsgTableCell";
    SystermMsgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SystermMsgTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


- (void)setModel:(SysterMsgModel *)model
{
    _model = model;
    _msgLabel.text = model.content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupSubVies];
    }
    return self;
}

- (void)setupSubVies
{
    self.msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.msgLabel.numberOfLines = 2;
    self.msgLabel.text = @"推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息推送消息";
    self.msgLabel.font = [UIFont systemFontOfSize:16];
    self.msgLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@44);
    }];
}

@end
