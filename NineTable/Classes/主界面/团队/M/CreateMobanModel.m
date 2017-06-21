//
//  CreateMobanModel.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CreateMobanModel.h"

@implementation CreateMobanModel

- (NSMutableArray<UIImage *> *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
