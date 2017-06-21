//
//  PayOrderView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

/********* 支付视图 *********/

@interface PayOrderView : UIView

// VIP套餐模型
@property (strong,nonatomic) VIPInfoModel *vipModel;
// 测试
@property (copy,nonatomic) void (^PayModelBlock)(WechatPayInfoModel *payModel);


@end
