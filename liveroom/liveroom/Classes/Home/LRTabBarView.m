//
//  LRTabBarView.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRTabBarView.h"

@interface LRTabBarView ()
@property (nonatomic, strong) UIView *chatRoomView;
@property (nonatomic, strong) UILabel *chatRoomTitleLabel;
@property (nonatomic, strong) UILabel *chatRoomDetailsLabel;

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIImageView *addImageView;

@property (nonatomic, strong) UIView *settingView;
@property (nonatomic, strong) UILabel *settingTitleLabel;
@property (nonatomic, strong) UILabel *settingDetailsLabel;
@end

@implementation LRTabBarView

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
    self.chatRoomView = [[UIView alloc] init];
    [self.chatRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        
    }];
}

@end
