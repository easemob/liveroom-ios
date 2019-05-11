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
#import "LRSpeakerCellModel.h"
#import "UIResponder+LRRouter.h"

NSString *ON_MIC_EVENT_NAME              = @"onMicEventName";
NSString *OFF_MIC_EVENT_NAME             = @"offMicEventName";
NSString *TALK_EVENT_NAME                = @"talkEventName";
NSString *ARGUMENT_EVENT_NAME            = @"argumentEventName";
NSString *UN_ARGUMENT_EVENT_NAME         = @"unArgumentEventName";
NSString *DISCONNECT_EVENT_NAME          = @"disconnectEventName";

@interface LRSpeakerCell ()
@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *crownImage;
@property (nonatomic, strong) LRVolumeView *volumeView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LRSpeakerCell

+ (LRSpeakerCell *)speakerCellWithType:(LRRoomType)aType
                             tableView:(UITableView *)aTableView
                             cellModel:(id)aModel {
    LRSpeakerCell *cell;
    switch (aType) {
        case LRRoomType_Host:
        {
            static NSString *hostCellId = @"Host";
            cell = [aTableView dequeueReusableCellWithIdentifier:hostCellId];
            if (!cell) {
                cell = [[LRSpeakerHostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hostCellId];
            }
        }
            break;
        case LRRoomType_Communication:
        {
            static NSString *CommunicationCellId = @"Communication";
            cell = [aTableView dequeueReusableCellWithIdentifier:CommunicationCellId];
            if (!cell) {
                cell = [[LRSpeakerCommunicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommunicationCellId];
            }
        }
            break;
        case LRRoomType_Monopoly:
        {
            static NSString *MonopolyCellId = @"Monopoly";
            cell = [aTableView dequeueReusableCellWithIdentifier:MonopolyCellId];
            if (!cell) {
                cell = [[LRSpeakerMonopolyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonopolyCellId];
            }
        }
            break;
        default:
            break;
    }
   
    [cell setModel:aModel];
    [cell updateSubViewUI];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = LRColor_HeightBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(streamIdsNoti:) name:LR_Stream_Did_Speaking_Notification object:nil];
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

- (void)streamIdsNoti:(NSNotification *)notification
{
    NSArray *array = notification.object;
    if (array.count != 0) {
        for (NSString *streamId in array) {
            if ([streamId isEqualToString:self.model.streamId]) {
                [self.volumeView setProgress:1];
            }
        }
    } else {
        [self.volumeView setProgress:0];
    }
}

- (void)updateSubViewUI {
    self.nameLabel.text = _model.username;
    self.lightView.backgroundColor = _model.speakOn ? [UIColor yellowColor] : LRColor_MiddleBlackColor;
    if (_model.isAdmin) {
        self.crownImage.hidden = NO;
    }else {
        self.crownImage.hidden = YES;
    }
    
    if (self.model.isMyself) {
        [self.contentView strokeWithColor:LRStrokeLowBlack];
    }
}

#pragma mark - actions
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface LRSpeakerHostCell ()
// 指定说话按钮
@property (nonatomic, strong) UIButton *talkBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
@end

@implementation LRSpeakerHostCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    [super _setupSubViews];
    [self.contentView addSubview:self.talkBtn];
    [self.contentView addSubview:self.disconnectBtn];
}

- (void)updateSubViewUI {
    [super updateSubViewUI];

    BOOL talkBtnNeedShow = self.model.type == LRRoomType_Host && self.model.isOwner;
    
    if (talkBtnNeedShow) {
        self.talkBtn.hidden = NO;
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(10);
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
    
    BOOL disconnectBtnNeedShow = (!self.model.isMyself && self.model.isOwner) || (self.model.isMyself && !self.model.isOwner);
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(talkBtnNeedShow ?
                              self.talkBtn.mas_right : self.contentView.mas_left).offset(10);
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
- (void)talkerAction:(UIButton *)aBtn {
    if (self.model.talkOn == NO) {
        [self btnSelectedWithEventName:TALK_EVENT_NAME];
    }
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

@end


@interface LRSpeakerCommunicationCell ()
// 音频开关按钮
@property (nonatomic, strong) UIButton *voiceEnableBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
@end

@implementation LRSpeakerCommunicationCell
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
    BOOL voiceEnableBtnNeedShow = self.model.type == LRRoomType_Communication && self.model.isMyself;
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

    BOOL disconnectBtnNeedShow = (!self.model.isMyself && self.model.isOwner) || (self.model.isMyself && !self.model.isOwner);
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(voiceEnableBtnNeedShow ?
                              self.voiceEnableBtn.mas_right : self.contentView.mas_left).offset(10);
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

@end

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
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        if (self.model.argumentOn) {
            [self.argumentBtn strokeWithColor:LRStrokeGreen];
            [self.argumentBtn setTitleColor:LRColor_LessBlackColor forState:UIControlStateNormal];
            self.argumentBtn.enabled = YES;
        }else {
            [self.argumentBtn strokeWithColor:LRStrokeLowBlack];
            [self.argumentBtn setTitleColor:LRColor_MiddleBlackColor forState:UIControlStateNormal];
            self.argumentBtn.enabled = NO;
        }
        
        [self.unArgumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.argumentBtn.mas_right).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        if (self.model.unArgumentOn) {
            [self.unArgumentBtn strokeWithColor:LRStrokeGreen];
            [self.unArgumentBtn setTitleColor:LRColor_LessBlackColor forState:UIControlStateNormal];
            self.unArgumentBtn.enabled = YES;
        }else {
            [self.unArgumentBtn strokeWithColor:LRStrokeLowBlack];
            [self.unArgumentBtn setTitleColor:LRColor_MiddleBlackColor forState:UIControlStateNormal];
            self.unArgumentBtn.enabled = NO;
        }
        [self.contentView cellStrokeWithColor:LRColor_LowBlackColor borderWidth:2.0];
        
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
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(argumentBtnNeedShow ?
                              self.unArgumentBtn.mas_right : self.contentView.mas_left).offset(10);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
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
        [_unArgumentBtn setTitle:@"释放麦" forState:UIControlStateNormal];
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
