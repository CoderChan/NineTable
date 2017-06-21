//
//  TeamMemberTableCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberTableCell : UITableViewCell

@property (strong,nonatomic) TeamMemberModel *model;
/** 初始化 */
+ (instancetype)sharedNormalCell:(UITableView *)tableView;

@end
