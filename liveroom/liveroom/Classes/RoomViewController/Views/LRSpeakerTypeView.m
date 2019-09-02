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
@property (nonatomic, strong) UILabel *titleLabel;  //会议模式
@property (nonatomic, strong) UILabel *infoLabel;   //模式介绍
@property (nonatomic, strong) UIButton *switchBtn;  //房间模式改变按钮/暂时没开发
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

#pragma mark - actions
- (void)switchBtnClicked:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(switchBtnClicked)]) {
        [_delegate switchBtnClicked];
    }
}

- (void)setupEnable:(BOOL)isEnable {
    if (isEnable) {
        self.switchBtn.hidden = NO;
    }else {
        self.switchBtn.hidden = YES;
    }
}

#pragma mark - setter
- (void)setType:(LRRoomType)type {
    _type = type;
    switch (_type) {
        case LRRoomType_Host:
        {
            self.titleLabel.text = @"主持模式";
            self.infoLabel.text = @"主持模式下管理员分配的主播获得发言权";
        }
            break;
        case LRRoomType_Monopoly:
        {
            self.titleLabel.text = @"抢麦模式";
            self.infoLabel.text = @"抢麦模式下所有主播通过抢麦获得发言权";
        }
            break;
        case LRRoomType_Communication:
        {
            self.titleLabel.text = @"自由麦模式";
            self.infoLabel.text = @"自由麦模式下所有主播可以自由发言";
        }
            break;
        case LRRoomType_Pentakill:
        {
            self.titleLabel.text = @"狼人杀模式";
            self.infoLabel.text = @"管理员admin可以随时切换发现范围，不同范围内的主播可以发言";
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.font = [UIFont systemFontOfSize:11];
        _infoLabel.textColor = LRColor_LowBlackColor;
    }
    return _infoLabel;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        [_switchBtn strokeWithColor:LRStrokeLowBlack];
        [_switchBtn addTarget:self
                       action:@selector(switchBtnClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

@end
