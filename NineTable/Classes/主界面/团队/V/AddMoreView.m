//
//  AddMoreView.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddMoreView.h"
#import <Masonry.h>
#import "NormalTableViewCell.h"

@interface AddMoreView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation AddMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(79, 79, 100, 0.1);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.array = @[@"添加分类",@"创建模板"];
    
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_more"]];
    backView.userInteractionEnabled = YES;
    backView.frame = CGRectMake(SCREEN_WIDTH - 10 - 150, 64, 150, 110);
    [self addSubview:backView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, backView.bounds.size.width, backView.bounds.size.height - 10)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor clearColor];
    [backView addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *iconArray = @[@"management_ico",@"template_management_ico"];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.titleLabel.text = self.array[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.row]];
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@24);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.DidSelectBlock) {
        _DidSelectBlock(indexPath.row);
        [self removeFromSuperview];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
