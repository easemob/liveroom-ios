//
//  LRSpeakerWerewolfkilledCell.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/22.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerPentakillCell.h"

NSString *PK_ON_MIC_EVENT_NAME              = @"pkOnMicEventName";
NSString *PK_OFF_MIC_EVENT_NAME             = @"pkOffMicEventName";
@interface LRSpeakerPentakillCell ()
// 音频开关按钮
@property (nonatomic, strong) UIButton *voiceEnableBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
@end

@implementation LRSpeakerPentakillCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    [super _setupSubViews];
    [self.contentView addSubview:self.voiceEnableBtn];
    [self.contentView addSubview:self.disconnectBtn];
}

- (void)updateSubViewUI {
    [super updateSubViewUI];
    BOOL voiceEnableBtnNeedShow = self.model.type == LRRoomType_Pentakill && self.model.isMyself;
    if (voiceEnableBtnNeedShow) {
        self.voiceEnableBtn.hidden = NO;
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
            make.width.equalTo(@(kBtnWidth));
            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
        
        
        if (self.model.speakOn) {
            [self.voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        }else {
            [self.voiceEnableBtn strokeWithColor:LRStrokeGreen];
        }
    }else {
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.voiceEnableBtn.hidden = YES;
    }
    
    BOOL disconnectBtnNeedShow = (!self.model.isMyself && self.model.isOwner) || (self.model.isMyself && !self.model.isOwner);
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            if (voiceEnableBtnNeedShow) {
                make.left.equalTo(self.voiceEnableBtn.mas_right).offset(10);
            } else {
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
}

#pragma mark - actions
- (void)voiceEnableAction:(UIButton *)aBtn {
    if (!self.model.speakOn) {
        [self btnSelectedWithEventName:PK_ON_MIC_EVENT_NAME];
    }else {
        [self btnSelectedWithEventName:PK_OFF_MIC_EVENT_NAME];
    }
}

- (UIButton *)voiceEnableBtn {
    if (!_voiceEnableBtn) {
        _voiceEnableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        [_voiceEnableBtn setTitle:@"发言" forState:UIControlStateNormal];
        [_voiceEnableBtn setTitle:@"发言" forState:UIControlStateSelected];
        [_voiceEnableBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voiceEnableBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _voiceEnableBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _voiceEnableBtn.backgroundColor = LRColor_PureBlackColor;
        [_voiceEnableBtn addTarget:self action:@selector(voiceEnableAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceEnableBtn;
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

@end

