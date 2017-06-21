//
//  TeamCateTableCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCateTableCell : UITableViewCell

@property (strong,nonatomic) MobanClassModel *model;

@property (copy,nonatomic) void (^LongPressBlock)(MobanClassModel *longModel);

+ (instancetype)sharedTeamCateCell:(UITableView *)tableView;

@end
