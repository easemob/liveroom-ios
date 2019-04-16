//
//  LRSettingSwitch.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSettingSwitch.h"

#define kPadding 1
@interface LRSettingSwitch ()

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIView *tagBackGroundView;
@property (nonatomic, assign) BOOL isAnimated;
@end

@implementation LRSettingSwitch

- (UIView *)tagBackGroundView{
    if (!_tagBackGroundView) {
        CGRect frame = self.isOn?CGRectMake(kPadding, kPadding,self.frame.size.width/2 - kPadding, self.frame.size.height - kPadding * 2):CGRectMake(self.frame.size.width/2,kPadding, self.frame.size.width/2 - kPadding,self.frame.size.height - kPadding * 2);
        _tagBackGroundView = [[UIView alloc] initWithFrame:frame];
    }
    return  _tagBackGroundView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews{
//    _isOn = YES;
//    _isAnimated = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    self.tagBackGroundView.userInteractionEnabled = YES;
    self.tagBackGroundView.backgroundColor = RGBACOLOR(126, 211, 33, 1.0);
    self.tagBackGroundView.layer.cornerRadius = self.tagBackGroundView.frame.size.height/10;
    self.tagBackGroundView.clipsToBounds = YES;
    [self addSubview:self.tagBackGroundView];

    self.tagView = [[UIView alloc] init];
    self.tagView.layer.borderColor = RGBACOLOR(80, 123, 32, 1.0).CGColor;
    self.tagView.layer.borderWidth = 1;
    self.tagView.layer.cornerRadius = self.tagView.frame.size.height/10;
    self.tagView.clipsToBounds = YES;
    self.tagView.backgroundColor = RGBACOLOR(126, 211, 33, 1.0);
    self.tagView.userInteractionEnabled = YES;
    [self.tagBackGroundView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagBackGroundView).offset(1);
        make.bottom.equalTo(self.tagBackGroundView).offset(-1);
        make.left.equalTo(self.tagBackGroundView).offset(1);
        make.right.equalTo(self.tagBackGroundView).offset(-1);
    }];
    self.backgroundColor = RGBACOLOR(37, 64, 6, 1.0);
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = self.frame.size.height/10;
    self.clipsToBounds = YES;
}

// isOn setter方法
- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    [self switchSettingWithOn:_isOn animated:_isAnimated];
    [self switchViewColorChange:_isOn];
}

// 开关打开，关闭设置
- (void)setOn:(BOOL)isOn animated:(BOOL)animated{
    _isOn = isOn;
    _isAnimated = animated;
    [self switchSettingWithOn:isOn animated:_isAnimated];
    [self switchViewColorChange:isOn];
}

- (void)switchViewColorChange:(BOOL)isOn
{
    if (isOn) {
        self.backgroundColor = RGBACOLOR(37, 64, 6, 1.0);
        self.tagBackGroundView.backgroundColor = RGBACOLOR(126, 211, 33, 1.0);
        self.tagView.backgroundColor = RGBACOLOR(126, 211, 33, 1.0);
        self.tagView.layer.borderColor = RGBACOLOR(80, 123, 32, 1.0).CGColor;
    } else {
        self.backgroundColor = RGBACOLOR(51, 51, 51, 1.0);
        self.tagBackGroundView.backgroundColor = RGBACOLOR(102, 102, 102, 1.0);
        self.tagView.backgroundColor = RGBACOLOR(153, 153, 153, 1.0);
        self.tagView.layer.borderColor = RGBACOLOR(102, 102, 102, 1.0).CGColor;
    }
}

- (void)switchSettingWithOn:(BOOL)isOn animated:(BOOL)animated
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (isOn) {
        [self animateWithPoint:CGPointMake(width/4 + kPadding/2,height/2) isAnimate:animated];
    }else{
        [self animateWithPoint:CGPointMake(3*width/4 - kPadding/2,height/2) isAnimate:animated];
    }
}

- (void)animateWithPoint:(CGPoint)point isAnimate:(BOOL)isAnimate
{
    if (isAnimate) {
        [UIView animateWithDuration:0.1
                              delay:0.01
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.tagBackGroundView.center = point;
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.tagBackGroundView.center = point;
    }
}

- (void)tap{
    self.isOn = !self.isOn;
    if ([self.delegate respondsToSelector:@selector(settingSwitchWithValueChanged:)]) {
        [self.delegate settingSwitchWithValueChanged:self];
    }
}

@end
