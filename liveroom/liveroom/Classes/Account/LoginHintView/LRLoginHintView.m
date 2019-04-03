//
//  LRLoginHintView.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/27.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRLoginHintView.h"
#import "Headers.h"

@interface LRLoginHintView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailsLabel;


@end

@implementation LRLoginHintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews
{
    self.backgroundColor = [UIColor redColor];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"timg.jpg"];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"正确 OK";
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    self.detailsLabel = [[UILabel alloc] init];
    self.detailsLabel.text = @"账号登录成功!";
    [self.detailsLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.detailsLabel];
    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
}

- (void)closeAction
{
    if ([self.delegate respondsToSelector:@selector(loginWithRegistStatus:)]) {
        [self.delegate loginWithRegistStatus:YES];
    }
}

@end
