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
    self.frame = CGRectMake(0, 0, 32, 32);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-material"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-3);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
    }];
}
@end
