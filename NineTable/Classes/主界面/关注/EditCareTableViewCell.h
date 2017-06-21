//
//  EditCareTableViewCell.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCareCellDelegate <NSObject>

- (void)editCareCellWithModel:(MobanClassModel *)model;

@end

@interface EditCareTableViewCell : UITableViewCell
/** 分类模型 */
@property (strong,nonatomic) MobanClassModel *model;
/** 编辑按钮 */
@property (strong,nonatomic) UIButton *editButton;
/** 编辑关注的代理 */
@property (weak,nonatomic) id<EditCareCellDelegate> delegate;
/** 初始化 */
+ (instancetype)sharedEditCareCell:(UITableView *)tableView;

@end
