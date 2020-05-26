//
//  LRSpeakerMonopolyCell.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/20.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerMonopolyCell.h"

NSString *ARGUMENT_EVENT_NAME            = @"argumentEventName";
NSString *UN_ARGUMENT_EVENT_NAME         = @"unArgumentEventName";
@interface LRSpeakerMonopolyCell ()
// 抢麦按钮
@property (nonatomic, strong) UIButton *argumentBtn;
// 释放麦按钮
@property (nonatomic, strong) UIButton *unArgumentBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
// 计时器timer
@property (nonatomic, strong) UILabel *timerLabel;
@end

@implementation LRSpeakerMonopolyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setupSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remainSpeakingTimerNoti:) name:LR_Remain_Speaking_timer_Notification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unArgumentSpeakerNoti:) name:LR_Un_Argument_Speaker_Notification object:nil];
    }
    return self;
}

- (void)remainSpeakingTimerNoti:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *speakingUserName = [dict objectForKey:@"currentSpeakingUsername"];
    NSNumber *remainSpeakingTime = [dict objectForKey:@"remainSpeakingTime"];
    self.timerLabel.text = nil;
    int time = [remainSpeakingTime intValue];
    if ([speakingUserName isEqualToString:self.model.username]) {
        if (time != 0) {
            self.timerLabel.text = [NSString stringWithFormat:@"%ds",time];
            self.timerLabel.hidden = NO;
        } else {
            self.timerLabel.text = nil;
            self.timerLabel.hidden = YES;
        }
    }
    
}

- (void)unArgumentSpeakerNoti:(NSNotification *)notification
{
    NSString *unArgumentSpeaker = notification.object;
    if ([unArgumentSpeaker isEqualToString:@""]) {
        self.timerLabel.text = nil;
        self.timerLabel.hidden = YES;
        [self.contentView disableStroke];
    }
}

- (void)_setupSubViews {
    [super _setupSubViews];
    [self.contentView addSubview:self.argumentBtn];
    [self.contentView addSubview:self.unArgumentBtn];
    [self.contentView addSubview:self.disconnectBtn];
    [self.contentView addSubview:self.timerLabel];
}

- (void)updateSubViewUI {
    [super updateSubViewUI];
    
    BOOL argumentBtnNeedShow = self.model.type == LRRoomType_Monopoly && self.model.isMyself;
    if (argumentBtnNeedShow) {
        self.argumentBtn.hidden = NO;
        self.unArgumentBtn.hidden = NO;
        [self.argumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
            make.width.equalTo(@(kBtnWidth));
            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
        
        if (self.model.argumentOn) {
            [self.argumentBtn strokeWithColor:LRStrokeGreen];
            [self.argumentBtn setTitleColor:LRColor_LessBlackColor forState:UIControlStateNormal];
            self.argumentBtn.enabled = YES;
        }else {
            [self.argumentBtn disableStroke];
            [self.argumentBtn setTitleColor:LRColor_MiddleBlackColor forState:UIControlStateNormal];
            self.argumentBtn.enabled = NO;
        }
        
        [self.unArgumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.argumentBtn);
            make.left.equalTo(self.argumentBtn.mas_right).offset(10);
            make.width.equalTo(@(kBtnWidth));
            //            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
        
        if (self.model.unArgumentOn) {
            [self.unArgumentBtn strokeWithColor:LRStrokeRed];
            [self.unArgumentBtn setTitleColor:LRColor_LessBlackColor forState:UIControlStateNormal];
            self.unArgumentBtn.enabled = YES;
        }else {
            [self.unArgumentBtn disableStroke];
            [self.unArgumentBtn setTitleColor:LRColor_MiddleBlackColor forState:UIControlStateNormal];
            self.unArgumentBtn.enabled = NO;
        }
    }else {
        [self.argumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.unArgumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.argumentBtn.hidden = YES;
        self.unArgumentBtn.hidden = YES;
    }
    
    BOOL disconnectBtnNeedShow = (!self.model.isMyself && self.model.isOwner) || (self.model.isMyself && !self.model.isOwner);
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            if (argumentBtnNeedShow) {
                make.left.equalTo(self.unArgumentBtn.mas_right).offset(10);
            }else {
                make.left.equalTo(self.nameLabel.mas_left);
            }
            make.width.equalTo(@(kBtnWidth));
            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
    }else {
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.disconnectBtn.hidden = YES;
    }
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.volumeView.mas_left).offset(-10);
    }];
}

#pragma mark - actions
- (void)argumentAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:ARGUMENT_EVENT_NAME];
}

- (void)unArgumentAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:UN_ARGUMENT_EVENT_NAME];
    self.timerLabel.text = nil;
    self.timerLabel.hidden = YES;
}


- (UIButton *)argumentBtn {
    if (!_argumentBtn) {
        _argumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_argumentBtn setTitle:@"抢麦" forState:UIControlStateNormal];
        [_argumentBtn setBackgroundColor:[UIColor blackColor]];
        [_argumentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_argumentBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _argumentBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _argumentBtn.backgroundColor = [UIColor blackColor];
        [_argumentBtn addTarget:self action:@selector(argumentAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _argumentBtn;
}

- (UIButton *)unArgumentBtn {
    if (!_unArgumentBtn) {
        _unArgumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unArgumentBtn setTitle:@"释放麦" forState:UIControlStateNormal];
        [_unArgumentBtn setBackgroundColor:[UIColor blackColor]];
        [_unArgumentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unArgumentBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _unArgumentBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _unArgumentBtn.backgroundColor = LRColor_PureBlackColor;
        [_unArgumentBtn addTarget:self action:@selector(unArgumentAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _unArgumentBtn;
}


- (UIButton *)disconnectBtn {
    if (!_disconnectBtn) {
        _disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disconnectBtn strokeWithColor:LRStrokeRed];
        [_disconnectBtn setTitle:@"下麦" forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _disconnectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _disconnectBtn.backgroundColor = LRColor_PureBlackColor;
        [_disconnectBtn addTarget:self action:@selector(disconnectAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _disconnectBtn;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.font = [UIFont systemFontOfSize:14];
        [_timerLabel setTextColor:LRColor_LessBlackColor];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.hidden = YES;
    }
    return _timerLabel;
}

@end
