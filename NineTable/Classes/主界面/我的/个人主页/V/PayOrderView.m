//
//  PayOrderView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PayOrderView.h"
#import "NormalTableViewCell.h"
#import <WXApiObject.h>
#import "WXApiManager.h"

@interface PayOrderView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *mengButton;
}
// 微信支付模型
@property (strong,nonatomic) WechatPayInfoModel *payModel;
/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
// 支付按钮
@property (strong,nonatomic) UIButton *button;
// 菊花
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

// 商品名称
@property (strong,nonatomic) UILabel *nameLabel;
// 支付方式
@property (strong,nonatomic) UIImageView *payTypeImgV;
// 总价格
@property (strong,nonatomic) UILabel *priceLabel;



@end

@implementation PayOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BottomHeight = 280;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    // 空白处
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(18, self.height - 18, self.width - 36, BottomHeight - 18)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 8;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.bottomView.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bottomView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.bottomView.layer.shadowRadius = 5;//阴影半径，默认3
    [self addSubview:self.bottomView];
    
    // 添加子控件
    [self addSubViewsAction];
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];
    
}

#pragma mark - 添加子控件-表格相关
- (void)addSubViewsAction
{
    self.array = @[@"VIP套餐",@"支付方式",@"支付总额"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = self.bottomView.backgroundColor;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.rowHeight = 60;
    [self.bottomView addSubview:self.tableView];
    
    
    // 2、footView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.width, 70)];
    footView.backgroundColor = self.bottomView.backgroundColor;
    footView.userInteractionEnabled = YES;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.enabled = NO;
    self.button.backgroundColor = DisAbledColor;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5;
    [self.button addTarget:self action:@selector(payOrderAction) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(20, 20, footView.width - 40, 44);
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [footView addSubview:self.button];
    
    [self.button addSubview:self.indicatorV];
    [self.indicatorV startAnimating];
    
    self.tableView.tableFooterView = footView;
    
    
    [[NineTableManager sharedManager].netManager getWechatPayInfoWithModel:self.vipModel Success:^(WechatPayInfoModel *wechatPayInfo) {
        
        if (self.PayModelBlock) {
            _PayModelBlock(wechatPayInfo);
        }
        self.payModel = wechatPayInfo;
        self.button.enabled = YES;
        [self.indicatorV stopAnimating];
        self.button.backgroundColor = MainColor;
        [self.button setTitle:@"确  定" forState:UIControlStateNormal];
        
    } Fail:^(NSString *errorMsg) {
        self.button.enabled = NO;
        [self.indicatorV stopAnimating];
        [self.button setTitle:errorMsg forState:UIControlStateNormal];
    }];
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
    if (indexPath.row == 0) {
        // VIP套餐
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentView addSubview:self.nameLabel];
        return cell;
    }else if (indexPath.row == 1){
        // 支付方式
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentView addSubview:self.payTypeImgV];
        return cell;
    }else{
        // 总金额
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.row];
        [cell.contentView addSubview:self.priceLabel];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

#pragma mark - 消失
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bottomView.width - 28 - 100, 15, 100, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.text = [NSString stringWithFormat:@"%@个月VIP",self.vipModel.time];
    }
    return _nameLabel;
}
- (UIImageView *)payTypeImgV
{
    if (!_payModel) {
        _payTypeImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat_pay"]];
        _payTypeImgV.frame = CGRectMake(self.bottomView.width - 28 - 30, 15, 30, 30);
    }
    return _payTypeImgV;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bottomView.width - 28 - 100, 15, 100, 30)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",self.vipModel.price];
        _priceLabel.textColor = WarningColor;
        _priceLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _priceLabel;
}
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.button.width/2 - 15, 7, 30, 30)];
        _indicatorV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _indicatorV;
}

#pragma mark - 微信支付
- (void)payOrderAction
{
    [self removeFromSuperview];
    
    PayReq *req = [[PayReq alloc] init];
    
    req.partnerId = self.payModel.partnerid; // 商家ID
    req.prepayId = self.payModel.prepayid; // 预支付订单ID
    req.nonceStr = self.payModel.noncestr; // 随机串，防重发
    req.timeStamp = [self.payModel.timestamp unsignedIntValue]; // 时间戳，防重发
    req.package = self.payModel.package; // 商家根据财付通文档填写的数据和签名
    req.sign = self.payModel.sign;  // 商家根据微信开放平台文档对数据做的签名
    
    [WXApi sendReq:req];
    
//    [YLNotificationCenter postNotificationName:WechatPayResultNoti object:nil userInfo:nil];
    
}



@end
