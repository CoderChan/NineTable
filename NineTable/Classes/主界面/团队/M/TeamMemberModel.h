//
//  TeamMemberModel.h
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamMemberModel : NSObject

/** 成员ID */
@property (copy,nonatomic) NSString *uid;
/** 成员名称 */
@property (copy,nonatomic) NSString *uname;
/** 成员头像 */
@property (copy,nonatomic) NSString *header_img;
/** 成员电话 */
@property (copy,nonatomic) NSString *phone;

// 性别
@property (copy,nonatomic) NSString *sex;
// 密码
@property (copy,nonatomic) NSString *enable_pwd;


@end
