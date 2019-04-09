//
//  LRVolumeView.m
//  testView
//
//  Created by 杜洁鹏 on 2019/4/9.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVolumeView.h"

@implementation LRVolumeView
{
    UIView *_lineView1;
    UIView *_lineView2;
    UIView *_lightView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];

    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews {
    self.backgroundColor = [UIColor blackColor];

    _lightView = [[UIView alloc] init];
    _lightView.backgroundColor = UIColor.yellowColor;
    _lineView1 = [[UIView alloc] init];
    _lineView1.backgroundColor = LRColor_HeightBlackColor;
    _lineView2 = [[UIView alloc] init];
    _lineView2.backgroundColor = LRColor_HeightBlackColor;
    
    [self addSubview:_lightView];
    [self addSubview:_lineView1];
    [self addSubview:_lineView2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lightView.frame = CGRectMake(0, CGRectGetHeight(self.frame) * _progress, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * (1 - _progress));
    CGFloat height = CGRectGetHeight(self.frame) / 5;
    _lineView1.frame = CGRectMake(0, height * 1, CGRectGetWidth(self.frame), height);
    _lineView2.frame = CGRectMake(0, height * 3, CGRectGetWidth(self.frame), height);
}

- (void)setProgress:(CGFloat)progress {
    _progress = 1 - progress;
    CGFloat height = _progress * CGRectGetHeight(self.frame);
    CGRect frame = _lightView.frame;
    frame.size.height = height;
    _lightView.frame = frame;
}

@end
