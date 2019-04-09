//
//  LRTitleView.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRTitleView.h"

@interface LRTitleView ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LRTitleView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews
{
    self.frame = CGRectMake(0, 0, LRWindowWidth, 50);
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(13);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.closeButton);
        make.width.equalTo(@220);
        make.height.equalTo(@20);
    }];
}

@end
