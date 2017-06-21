//
//  VIPTableViewCell.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VIPTableViewCell.h"


@interface VIPTableViewCell ()

@property (strong,nonatomic) UIButton *buyButton;

@end

@implementation VIPTableViewCell

+ (instancetype)sharedVIPCell:(UITableView *)tableView
{
    static NSString *ID = @"VIPTableViewCell";
    VIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VIPTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(VIPInfoModel *)model
{
    _model = model;
    self.textLabel.text = [NSString stringWithFormat:@"%@个月%@元",model.time,model.price];
}

- (void)setupSubViews
{
    // 高度70
    __weak VIPTableViewCell *copySelf = self;
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.frame = CGRectMake(SCREEN_WIDTH - 60 - 21, 15, 60, 38);
    self.buyButton.backgroundColor = WarningColor;
    self.buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.cornerRadius = 4;
    [self.buyButton setTitle:@"购买" forState:UIControlStateNormal];
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (copySelf.PayVIPBlock) {
            copySelf.PayVIPBlock(copySelf.model);
        }
    }];
    [self.contentView addSubview:self.buyButton];
    
}

@end
