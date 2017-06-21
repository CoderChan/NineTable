//
//  MyMobanTableCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMobanTableCell : UITableViewCell

@property (strong,nonatomic) MobanInfoModel *model;

+ (instancetype)sharedMyMobanCell:(UITableView *)tableView;

@end
