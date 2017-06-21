//
//  SearchFieldView.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFieldView : UIView

/** 搜索的 */
@property (copy,nonatomic) void (^SearchResultBlock)(NSString *searchKey);

@end
