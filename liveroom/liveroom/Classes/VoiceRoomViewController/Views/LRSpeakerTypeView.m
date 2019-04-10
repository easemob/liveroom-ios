//
//  LRSpeakerTypeView.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakerTypeView.h"
#import "Headers.h"

@interface LRSpeakerTypeView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *switchBtn;
@end

@implementation LRSpeakerTypeView
- (instancetype)init {
    if (self = [super init]) {
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.switchBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.6);
        make.right.equalTo(self.switchBtn.mas_left).offset(-5);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.width.equalTo(@25);
    }];
}

#pragma mark - setter
- (void)setType:(LRSpeakerType)type {
    _type = type;
    switch (_type) {
        case LRSpeakerType_Host:
        {
            self.titleLabel.text = @"主持模式 Host";
            self.infoLabel.text = @"只有管理员admin可以控制发言";
        }
            break;
        case LRSpeakerType_Monopoly:
        {
            self.titleLabel.text = @"抢麦模式 monopoly";
            self.infoLabel.text = @"管理员和主播可以互相抢麦发言，管理员可以控制所发言，主播仅能抢麦发言";
        }
            break;
        case LRSpeakerType_Communication:
        {
            self.titleLabel.text = @"自由麦模式 communication";
            self.infoLabel.text = @"管理员和主播均能自由控制自己的发言，管理员可以控制所有发言";
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.textColor = LRColor_LowBlackColor;
    }
    return _infoLabel;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        [_switchBtn strokeWithColor:LRStrokeLowBlack];
    }
    return _switchBtn;
}

@end
