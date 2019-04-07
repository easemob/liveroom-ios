//
//  LRSettingSwitch.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSettingSwitch.h"

@interface LRSettingSwitch ()
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, assign) BOOL isAnimated;
@end

@implementation LRSettingSwitch
@synthesize isOn = _isOn;

- (UILabel*)tagLabel{
    if (!_tagLabel) {
        CGRect frame = self.isOn?CGRectMake(5, 5,self.frame.size.width/2 - 5, self.frame.size.height - 10):CGRectMake(self.frame.size.width/2,5, self.frame.size.width/2 - 5,self.frame.size.height - 10);
        _tagLabel = [[UILabel alloc] initWithFrame:frame];
    }
    return  _tagLabel;
}
- (UILabel*)leftLabel{
    if (!_leftLabel) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        _leftLabel = [[UILabel alloc] initWithFrame:frame];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
- (UILabel*)rightLabel{
    if (!_rightLabel) {
        CGRect frame = CGRectMake(self.frame.size.width/2,0, self.frame.size.width/2, self.frame.size.height);
        _rightLabel = [[UILabel alloc] initWithFrame:frame];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _isOn = YES;
    _isAnimated = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.tagLabel addGestureRecognizer:tap];
    self.tagLabel.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    self.rightLabel.backgroundColor = RGBACOLOR(37, 63, 11, 1.0);
    [self addSubview:self.rightLabel];
    self.leftLabel.backgroundColor = RGBACOLOR(37, 63, 11, 1.0);
    [self addSubview:self.leftLabel];
    self.tagLabel.backgroundColor = RGBACOLOR(129, 209, 52, 1.0);
    [self addSubview:self.tagLabel];
    self.layer.cornerRadius = self.frame.size.height/10;
    self.clipsToBounds = YES;
}

// isOn setter方法
- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    [self switchSettingWithOn:_isOn animated:_isAnimated];
}

- (BOOL)isOn
{
//    NSLog(@"_isOn---%d", _isOn);
    return _isOn;
}

// 开关打开，关闭设置
- (void)setOn:(BOOL)on animated:(BOOL)animated{
    _isAnimated = animated;
    [self switchSettingWithOn:on animated:_isAnimated];
}

- (void)switchSettingWithOn:(BOOL)isOn animated:(BOOL)animated
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (isOn) {
        [self animateWithPoint:CGPointMake(width/4+2.5,height/2) isAnimate:animated];
    }else{
        [self animateWithPoint:CGPointMake(3*width/4-2.5,height/2) isAnimate:animated];
    }
}

- (void)animateWithPoint:(CGPoint)point isAnimate:(BOOL)isAnimate
{
    if (isAnimate) {
        [UIView animateWithDuration:0.5
                              delay:0.01
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.tagLabel.center = point;
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.tagLabel.center = point;
    }
}

- (void)tap{
    self.isOn = !self.isOn;
    if ([self.delegate respondsToSelector:@selector(settingSwitchWithIsOn:)]) {
        [self.delegate settingSwitchWithIsOn:self.isOn];
    }
}


@end
