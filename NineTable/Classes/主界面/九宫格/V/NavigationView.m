//
//  NavigationView.m
//  NineTable
//
//  Created by Chan_Sir on 2017/6/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    
    self.xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, self.width, 2)];
    self.xian.image = [UIImage imageNamed:@"xian"];
    self.xian.alpha = 0;
    [self addSubview:self.xian];
}

@end
