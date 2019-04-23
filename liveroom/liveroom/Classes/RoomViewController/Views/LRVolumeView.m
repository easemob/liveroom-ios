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
    NSTimer *_timer;
    NSArray *_speakAnimationImages;
    UIImageView *_lightImageView;
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
    _speakAnimationImages = @[@"voice1",@"voice2",@"voice3",@"voice4"];
    self.backgroundColor = [UIColor clearColor];
    _lightImageView = [[UIImageView alloc] init];
    _lightImageView.image = [UIImage imageNamed:@"voice1"];
    _lightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_lightImageView];
}

- (void)startSpeakAnimationImage
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(speakAnimationImage)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)speakAnimationImage
{
    _lightImageView.image = [UIImage imageNamed:[_speakAnimationImages objectAtIndex:0]];
    NSUInteger value = (NSUInteger)arc4random() % 4;
    NSUInteger count = [_speakAnimationImages count];
    if (value >= count) {
        _lightImageView.image = [UIImage imageNamed:[_speakAnimationImages lastObject]];
    } else {
        _lightImageView.image = [UIImage imageNamed:[_speakAnimationImages objectAtIndex:value]];
    }
}

- (void)endSpeakAnimationImage
{
    [_timer invalidate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lightImageView.frame = self.bounds;
}

- (void)setProgress:(CGFloat)progress {
//    _progress = 1 - progress;
//    CGFloat height = _progress * CGRectGetHeight(self.frame);
//    CGRect frame = _lightView.frame;
//    frame.size.height = height;
//    _lightView.frame = frame;
}

@end
