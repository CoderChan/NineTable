//
//  NormalTableViewCell.h
//  FYQ
//
//  Created by Chan_Sir on 2016/11/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableViewCell : UITableViewCell

/** 图标 */
@property (strong,nonatomic) UIImageView *iconView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 初始化 */
+ (instancetype)sharedNormalCell:(UITableView *)tableView;

@end
