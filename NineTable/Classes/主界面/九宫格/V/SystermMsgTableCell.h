//
//  SystermMsgTableCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystermMsgTableCell : UITableViewCell

@property (strong,nonatomic) SysterMsgModel *model;

+ (instancetype)sharedSystermCell:(UITableView *)tableView;

@end
