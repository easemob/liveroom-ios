//
//  LRFindView.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRFindView.h"

@implementation LRFindView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews
{
    self.frame = CGRectMake(0, 0, 40, 35);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.right.equalTo(self);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
}
@end
