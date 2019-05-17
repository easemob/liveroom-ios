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
    _lightImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_lightImageView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _lightImageView.frame = self.bounds;
}

- (void)setProgress:(NSUInteger)progress {
    _progress = progress;
    if (progress != 0) {
        NSUInteger value = 1 + (NSUInteger)arc4random() % 3;
        _lightImageView.image = [UIImage imageNamed:[_speakAnimationImages objectAtIndex:value]];
    } else {
        _lightImageView.image = [UIImage imageNamed:[_speakAnimationImages objectAtIndex:progress]];
    }
    
}

@end
