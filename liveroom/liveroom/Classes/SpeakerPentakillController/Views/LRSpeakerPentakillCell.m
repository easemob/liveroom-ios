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
//身份图片
@property (nonatomic, strong) UIImageView *identityImage;
@end

@implementation LRSpeakerPentakillCell

static dispatch_once_t onceToken;
static LRSpeakerPentakillCell *identity;
+ (LRSpeakerPentakillCell *)sharedInstance {
    dispatch_once(&onceToken, ^{
        identity = [[LRSpeakerPentakillCell alloc] init];
    });
    return identity;
}
- (void)destoryInstance {
    onceToken = 0;
    identity = nil;
}

//显示/隐藏 狼人杀模式身份图标
- (void)updateIdentity {
    if((!self.model.isMyself) && [LRSpeakHelper.sharedInstance.clockStatus isEqualToString:@"LRTerminator_dayTime"]){
        self.identityImage.hidden = YES;
        
    }else if([LRSpeakHelper.sharedInstance.clockStatus isEqualToString:@"LRTerminator_night"]){
        self.identityImage.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    [super _setupSubViews];
    self.identityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubViewUI)
                                                 name:LR_WEREWOLF_DIDCHANGE
                                               object:nil];
    [self.contentView addSubview:self.identityImage];
    [self.contentView addSubview:self.voiceEnableBtn];
    [self.contentView addSubview:self.disconnectBtn];
}
// 管理员皇冠👑 & cell 边框
- (void)updateSubViewUI {
    [super updateSubViewUI];
    if(self.model.isAdmin){
        [self.identityImage mas_remakeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.nameLabel);
            make.left.equalTo(self.crownImage.mas_right).offset(5);
            make.height.width.equalTo(@12);
        }];
    }else{
        [self.identityImage mas_remakeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.nameLabel);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.height.width.equalTo(@12);
        }];
    }
    
    //l狼人杀模式设置身份图片
    BOOL key = true;
    for (NSString *str in LRSpeakHelper.sharedInstance.identityDic) {
        NSLog(@"\n---------->useronline:    %@",str);
    }
    for(NSString *strIdentity in LRSpeakHelper.sharedInstance.identityDic){
        NSLog(@"\n------------->stridentity:    %@",strIdentity);
        if([self.model.username isEqualToString:strIdentity])
        {
            self.identityImage.image = [UIImage imageNamed:@"werewolf"];
            key = false;
            break;
        }
    }
    if(key){
        self.identityImage.image = [UIImage imageNamed:@"villager"];
    }
    //设置身份白天只有自己可见。
    [self updateIdentity];
    
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

