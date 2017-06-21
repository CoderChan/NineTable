//
//  MineTableHeadView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/3/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UserInfoModel.h"

@interface MineTableHeadView : UIView

//@property (strong,nonatomic) UserInfoModel *userModel;

@property (copy,nonatomic) void (^ClickBlock)();

@end
