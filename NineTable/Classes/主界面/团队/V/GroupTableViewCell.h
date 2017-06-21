//
//  GroupTableViewCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell

/** 背景 */
@property (strong,nonatomic) UIView *backView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 初始化 */
+ (instancetype)sharedGroupTableCell:(UITableView *)tableView;

@end
