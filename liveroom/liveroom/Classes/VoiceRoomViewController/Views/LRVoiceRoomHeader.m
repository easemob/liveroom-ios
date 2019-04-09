//
//  LRVoiceRoomHeader.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVoiceRoomHeader.h"
#import "LRMusicPlayerHelper.h"
#import "Headers.h"


#define kItemPadding 10
#define kItemSize 35

@interface LRVoiceRoomHeaderItem ()
@property (nonatomic) SEL action;
@property (nonatomic, weak) id target;
@end

@implementation LRVoiceRoomHeaderItem
+ (LRVoiceRoomHeaderItem *)itemWithImage:(UIImage *)aImg
                                  target:(id)aTarget
                                  action:(SEL)aAction
{
    LRVoiceRoomHeaderItem *btn = [LRVoiceRoomHeaderItem buttonWithType:UIButtonTypeCustom];
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn strokeWithColor:LRStrokeLowBlack];
    if (aAction) btn.action = aAction;
    if (aTarget) btn.target = aTarget;
    return btn;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end

@interface LRVoiceRoomHeader()
{
    CGFloat _leftItemX;
    int _musictimer;
    NSString *_musicName;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) LRVoiceRoomHeaderPlayerView *playerView;
@end

@implementation LRVoiceRoomHeader

- (instancetype)initWithTitle:(NSString *)aTitle info:(NSString *)aInfo {
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLabel];
        
        if (aTitle) self.titleLabel.text = aTitle;
        if (aInfo) self.infoLabel.text = aInfo;
        
        [self addSubview:self.playerView];
        [self setupPlayerView];
    }
    return self;
}

#pragma mark - subViews
- (void)setupPlayerView {
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(kItemPadding);
    }];
}

- (void)setupTitleLabelSize {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self).offset(-(self->_leftItemX));
        make.height.equalTo(@(kItemSize - 15));
    }];
    
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.height.equalTo(@(15));
    }];
}

#pragma mark - public

#pragma mark - private
- (void)removeItems {
    for (LRVoiceRoomHeaderItem *item in _actionList) {
        [item removeFromSuperview];
    }
}

- (void)addItems {
    __block CGFloat left = 0;
    for (int i = (int)_actionList.count - 1; i >= 0; i--) {
        LRVoiceRoomHeaderItem *item = _actionList[i];
        [item addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        int count = (int)self.actionList.count - 1 - i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.width.height.equalTo(@kItemSize);
            left = (kItemPadding + kItemSize) * count;
            make.right.equalTo(self).offset(-left);
        }];
    }
    _leftItemX = left + kItemPadding + kItemSize;
}

- (void)itemDidClicked:(LRVoiceRoomHeaderItem *)aItem {
    if (aItem.target && aItem.action) {
        SEL selector = aItem.action;
        IMP imp = [aItem.target methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(aItem.target, selector);
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:13];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.numberOfLines = 1;
    }
    return _infoLabel;
}

- (LRVoiceRoomHeaderPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[LRVoiceRoomHeaderPlayerView alloc] init];
    }
    return _playerView;
}


#pragma mark - setter
- (void)setActionList:(NSArray *)actionList {
    if (_actionList && _actionList.count > 0) {
        [self removeItems];
    }
    _actionList = actionList;
    
    if (_actionList && _actionList.count > 0) {
        [self addItems];
    }
    
    [self setupTitleLabelSize];
}

@end


@interface LRVoiceRoomHeaderPlayerView () <LRMusicPlayerHelperDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation LRVoiceRoomHeaderPlayerView
- (instancetype)init {
    if (self = [super init]) {
        [self editEnable:YES];
        [[LRMusicPlayerHelper sharedInstance] addDelegate:self delegateQueue:nil];
        self.backgroundColor = LRColor_HeightBlackColor;
        [self addSubview:self.nameLabel];
        [self addSubview:self.playBtn];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.totalTimeLabel];
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - LRMusicPlayerHelperDelegate
- (void)musicDidChanged:(LRMusicItem *)item {
    self.nameLabel.text = item.itemName;
    self.totalTimeLabel.text = [self _strFromTimer:item.totalTime];
}

- (void)currentTimeChanged:(int)currentTime totalTime:(int)aTotalTime {
    self.currentTimeLabel.text = [self _strFromTimer:currentTime];
    CGFloat progress = (CGFloat)currentTime / (CGFloat)aTotalTime;
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(9);
        make.height.equalTo(@15);
        make.right.equalTo(self).offset(-30);
    }];
    
    [self.playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(2);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(-3);
    }];
    
    [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).priorityLow();
        make.right.equalTo(self.progressView.mas_left).offset(-5);
        make.centerY.equalTo(self.progressView);
    }];
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-12);
        make.height.equalTo(@(8));
    }];
    
    [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self.progressView.mas_right).offset(5);
        make.centerY.equalTo(self.progressView);
    }];
}

#pragma mark - public
- (void)editEnable:(BOOL)isEnable {
    self.playBtn.hidden = !isEnable;
    if (isEnable) {
        [self strokeWithColor:LRStrokeLowBlack];
    }else {
        [self disableStroke];
    }
}


#pragma mark - private
- (NSString *)_strFromTimer:(int)aTimer {
    int min = aTimer / 60;
    int sec = aTimer % 60;
    return [NSString stringWithFormat:@"%02d:%02d",min, sec];
}

#pragma mark - actions
- (void)playBtnAction:(UIButton *)btn {
    if (btn.selected) {
        [[LRMusicPlayerHelper sharedInstance] pause];
    }else {
        [[LRMusicPlayerHelper sharedInstance] play];
    }
    btn.selected = !btn.selected;
}

#pragma mark - getter
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.progressTintColor = LRColor_LowBlackColor;
        _progressView.trackTintColor = LRColor_MiddleBlackColor;
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.font = [UIFont systemFontOfSize:11];
        _totalTimeLabel.textColor = LRColor_LowBlackColor;
    }
    return _totalTimeLabel;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel  = [[UILabel alloc] init];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.font = [UIFont systemFontOfSize:11];
        _currentTimeLabel.textColor = LRColor_LowBlackColor;
    }
    return _currentTimeLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = LRColor_MiddleBlackColor;
        _nameLabel.text = @"";
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    return _nameLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

@end

