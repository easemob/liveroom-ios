//
//  LRSpeakerCell.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakerCell.h"
#import "Headers.h"
#import "LRVolumeView.h"

#import "UIResponder+LRRouter.h"

NSString *ON_MIC_EVENT_NAME              = @"onMicEventName";
NSString *OFF_MIC_EVENT_NAME             = @"offMicEventName";
NSString *TALK_EVENT_NAME                = @"talkEventName";
NSString *ARGUMENT_EVENT_NAME            = @"offMicEventName";
NSString *UN_ARGUMENT_EVENT_NAME         = @"offMicEventName";
NSString *DISCONNECT_EVENT_NAME          = @"disconnectEventName";

@interface LRSpeakerCell ()
@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *crownImage;
@property (nonatomic, strong) LRVolumeView *volumeView;
@property (nonatomic, strong) UIView *lineView;

// 音频开关按钮
@property (nonatomic, strong) UIButton *voiceEnableBtn;
// 指定说话按钮
@property (nonatomic, strong) UIButton *talkBtn;
// 抢麦按钮
@property (nonatomic, strong) UIButton *argumentBtn;
// 释放麦按钮
@property (nonatomic, strong) UIButton *unArgumentBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
@end

@implementation LRSpeakerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = LRColor_HeightBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.contentView addSubview:self.lightView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.crownImage];
    [self.contentView addSubview:self.volumeView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.voiceEnableBtn];
    [self.contentView addSubview:self.talkBtn];
    [self.contentView addSubview:self.argumentBtn];
    [self.contentView addSubview:self.unArgumentBtn];
    [self.contentView addSubview:self.disconnectBtn];
    
    [self.lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.width.height.equalTo(@8);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.lessThanOrEqualTo(self.volumeView.mas_left).offset(-32);
        make.bottom.equalTo(self.lineView.mas_top).offset(-10).priorityLow();
    }];
    
    [self.crownImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.height.width.equalTo(@25);
    }];
    
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@10);
        make.height.equalTo(@18);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@2);
    }];
    
    [self layoutIfNeeded];
}

- (void)updateSubViewUI {
    
    BOOL voiceEnableBtnNeedShow = NO;
    BOOL talkBtnNeedShow = NO;
    BOOL argumentBtnNeedShow = NO;
    BOOL disconnectBtnNeedShow = NO;
    
    // 如果有数据
    if (![_model.username isEqualToString:@""]) {
        self.nameLabel.text = _model.username;
        self.lightView.backgroundColor = _model.speakOn ? [UIColor yellowColor] : LRColor_MiddleBlackColor;
        if (_model.isAdmin) {
            self.crownImage.hidden = NO;
        }else {
            self.crownImage.hidden = YES;
        }
        
        voiceEnableBtnNeedShow = _model.type == LRRoomType_Communication && _model.isMyself;
        
        talkBtnNeedShow = _model.type == LRRoomType_Host && _model.isOwner;
        
        argumentBtnNeedShow = _model.type == LRRoomType_Monopoly && _model.isMyself;
        
        disconnectBtnNeedShow = (!_model.isMyself && _model.isOwner) || (_model.isMyself && !_model.isOwner);
    } else {
        self.nameLabel.text = @"已下线";
        self.lightView.backgroundColor = LRColor_LowBlackColor;
        self.crownImage.hidden = YES;
    }
    
    if (voiceEnableBtnNeedShow) {
        self.voiceEnableBtn.hidden = NO;
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.lightView);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        
        if (self.model.speakOn) {
            [self.voiceEnableBtn strokeWithColor:LRStrokeGreen];
        }else {
            [self.voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        }
        
    }else {
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.voiceEnableBtn.hidden = YES;
    }
    
    if (talkBtnNeedShow) {
        self.talkBtn.hidden = NO;
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(!voiceEnableBtnNeedShow ? self.contentView.mas_left: self.voiceEnableBtn.mas_right).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        if (self.model.talkOn) {
            [self.talkBtn strokeWithColor:LRStrokeGreen];
        }else {
            [self.talkBtn strokeWithColor:LRStrokeLowBlack];
        }
        
    }else {
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.talkBtn.hidden = YES;
    }
    
    if (argumentBtnNeedShow) {
        self.argumentBtn.hidden = NO;
        self.unArgumentBtn.hidden = NO;
        [self.argumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(!talkBtnNeedShow ? self.contentView.mas_left: self.talkBtn.mas_right).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        if (self.model.argumentOn) {
            [self.argumentBtn strokeWithColor:LRStrokeGreen];
        }else {
            [self.argumentBtn strokeWithColor:LRStrokeLowBlack];
        }
        
        [self.unArgumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.argumentBtn.mas_right).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        if (self.model.unArgumentOn) {
            [self.unArgumentBtn strokeWithColor:LRStrokeGreen];
        }else {
            [self.unArgumentBtn strokeWithColor:LRStrokeLowBlack];
        }

    }else {
        [self.argumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.unArgumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.argumentBtn.hidden = YES;
        self.unArgumentBtn.hidden = YES;
    }
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(!voiceEnableBtnNeedShow ? (!argumentBtnNeedShow ? self.contentView.mas_left: self.unArgumentBtn.mas_right) : self.voiceEnableBtn.mas_right).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
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
        [self btnSelectedWithEventName:ON_MIC_EVENT_NAME];
    }else {
        [self btnSelectedWithEventName:OFF_MIC_EVENT_NAME];
    }
}

- (void)talkerAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:TALK_EVENT_NAME];
}

- (void)argumentAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:ARGUMENT_EVENT_NAME];
}

- (void)unArgumentAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:UN_ARGUMENT_EVENT_NAME];
}

- (void)disconnectAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:DISCONNECT_EVENT_NAME];
}

- (void)btnSelectedWithEventName:(NSString *)aEventName {
    [self routerEventWithName:aEventName userInfo:@{@"key" : self.model}];
}


#pragma mark - getter
- (UIView *)lightView {
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _lightView.layer.masksToBounds = YES;
        _lightView.layer.cornerRadius = 4;
        _lightView.backgroundColor = [UIColor yellowColor];
    }
    return _lightView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    return _nameLabel;
}

- (UIImageView *)crownImage {
    if (!_crownImage) {
        _crownImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _crownImage.image = [UIImage imageNamed:@"crown"];
    }
    return _crownImage;
}

- (LRVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[LRVolumeView alloc] initWithFrame:CGRectZero];
        _volumeView.backgroundColor = [UIColor blackColor];
        _volumeView.progress = 0.5;
    }
    return _volumeView;
}

- (UIButton *)voiceEnableBtn {
    if (!_voiceEnableBtn) {
        _voiceEnableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        [_voiceEnableBtn setTitle:@"打开麦克风" forState:UIControlStateNormal];
        [_voiceEnableBtn setTitle:@"关闭麦克风" forState:UIControlStateSelected];
        [_voiceEnableBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voiceEnableBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _voiceEnableBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_voiceEnableBtn addTarget:self action:@selector(voiceEnableAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceEnableBtn;
}

- (UIButton *)talkBtn {
    if (!_talkBtn) {
        _talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_talkBtn strokeWithColor:LRStrokeLowBlack];
        [_talkBtn setTitle:@"发言" forState:UIControlStateNormal];
        [_talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_talkBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _talkBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_talkBtn addTarget:self action:@selector(talkerAction:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _talkBtn;
}

- (UIButton *)argumentBtn {
    if (!_argumentBtn) {
        _argumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_argumentBtn strokeWithColor:LRStrokeLowBlack];
        [_argumentBtn setTitle:@"抢麦" forState:UIControlStateNormal];
        [_argumentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_argumentBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _argumentBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_argumentBtn addTarget:self action:@selector(argumentAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _argumentBtn;
}

- (UIButton *)unArgumentBtn {
    if (!_unArgumentBtn) {
        _unArgumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unArgumentBtn strokeWithColor:LRStrokeLowBlack];
        [_unArgumentBtn setTitle:@"释放" forState:UIControlStateNormal];
        [_unArgumentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unArgumentBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _unArgumentBtn.titleLabel.font = [UIFont systemFontOfSize:11];
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
        [_disconnectBtn addTarget:self action:@selector(disconnectAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _disconnectBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

@end

@implementation LRSpeakerCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.username = @"";
    }
    return self;
}
@end
