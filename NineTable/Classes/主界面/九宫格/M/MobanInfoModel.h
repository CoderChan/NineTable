//
//  MobanInfoModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobanInfoModel : NSObject

/** 模板ID */
@property (copy,nonatomic) NSString *tid;
/** 模板名称 */
@property (copy,nonatomic) NSString *template_name;
/** 模板文字 */
@property (copy,nonatomic) NSString *template_content;
/** 缩略图 */
@property (copy,nonatomic) NSString *thumb;
/** 图片数组 */
@property (copy,nonatomic) NSArray *imgurl;


// 创建时间、我创建的模板列表使用
@property (copy,nonatomic) NSString *create_time;

@end
