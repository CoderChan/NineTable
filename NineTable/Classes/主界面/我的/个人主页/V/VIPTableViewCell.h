//
//  VIPTableViewCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPTableViewCell : UITableViewCell

@property (strong,nonatomic) VIPInfoModel *model;

@property (copy,nonatomic) void (^(PayVIPBlock))(VIPInfoModel *vipModel);

+ (instancetype)sharedVIPCell:(UITableView *)tableView;

@end
