//
//  LRSpeakHelper.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "Headers.h"
#import "LRSpeakHelper.h"
#import "LRGCDMulticastDelegate.h"
#import "LRRoomModel.h"

#define kKeepHandleTime 30.00

@interface LRSpeakHelper () <EMConferenceManagerDelegate>
{
    LRGCDMulticastDelegate <LRSpeakHelperDelegate> *_delegates;
    NSString *_currentMonopolyTalker;
    BOOL _isPlaying;
    int _time;
}

@property (nonatomic, strong) NSString *pubStreamId;
@property (nonatomic, strong) NSTimer *monopolyTimer;
@end

@implementation LRSpeakHelper
+ (LRSpeakHelper *)sharedInstance {
    static dispatch_once_t onceToken;
    static LRSpeakHelper *helper_;
    dispatch_once(&onceToken, ^{
        helper_ = [[LRSpeakHelper alloc] init];
    });
    return helper_;
}

- (instancetype)init {
    if (self = [super init]) {
        _delegates = (LRGCDMulticastDelegate<LRSpeakHelperDelegate> *)[[LRGCDMulticastDelegate alloc] init];
        [EMClient.sharedClient.conferenceManager addDelegate:self delegateQueue:nil];
        
        // 监听输出设备变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioRouteChangeListenerCallback:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:[AVAudioSession sharedInstance]];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(agreedToBeAudience:)
                                                   name:LR_Receive_ToBe_Audience_Notification
                                                 object:nil];
    }
    return self;
}

- (void)addDeelgate:(id<LRSpeakHelperDelegate>)aDelegate delegateQueue:(dispatch_queue_t)aQueue {
    if (!aQueue) {
        aQueue = dispatch_get_main_queue();
    }
    [_delegates addDelegate:aDelegate delegateQueue:aQueue];
}

- (void)removeDelegate:(id<LRSpeakHelperDelegate>)aDelegate {
    [_delegates removeDelegate:aDelegate];
}

// 加入语音会议
- (void)joinSpeakRoomWithConferenceId:(NSString *)aConferenceId
                       password:(NSString *)aPassword
                     completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.conferenceManager joinConferenceWithConfId:aConferenceId
                                                             password:aPassword
                                                           completion:^(EMCallConference *aCall, EMError *aError)
     {
         if (!aError) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf loudspeaker];
             });
             weakSelf.conference = aCall;
             [EMClient.sharedClient.conferenceManager startMonitorSpeaker:weakSelf.conference
                                                             timeInterval:500
                                                               completion:^(EMError *aError)
              {
                  
              }];
         }
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}

// 离开语音会议
- (void)leaveSpeakRoomWithRoomId:(NSString *)aRoomId
                      completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    _isPlaying = NO;
    [EMClient.sharedClient.conferenceManager leaveConference:self.conference
                                                  completion:^(EMError *aError)
     {
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}


// 设置房间属性
- (void)setupRoomType:(LRRoomType)aType {
    NSString *value;
    switch (aType) {
        case LRRoomType_Communication:
        {
            value = @"communication";
        }
            break;
        case LRRoomType_Host:
        {
            value = @"host";
        }
            break;
        case LRRoomType_Monopoly:
        {
            value = @"monopoly";
        }
            break;
        default:
            break;
    }
    if (value) {
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"type" value:value completion:^(EMError *aError)
        {
                                                                 
        }];
    }
}

// 发布自己的流，并更新ui
- (void)setupMySelfToSpeaker {
    __weak typeof(self) weakSekf = self;
    EMStreamParam *param = [[EMStreamParam alloc] init];
    param.streamName = kCurrentUsername;
    param.enableVideo = NO;
    // 如果是互动模式 主播模式(群主)，上麦可以直接说话
    __block BOOL isMute = YES;
    BOOL isOwner = [self.roomModel.owner isEqualToString:kCurrentUsername];
    isMute = !((isOwner && self.roomModel.roomType == LRRoomType_Host)
               || (self.roomModel.roomType == LRRoomType_Communication));
    param.isMute = isMute;
    [EMClient.sharedClient.conferenceManager publishConference:self.conference
                                                   streamParam:param
                                                    completion:^(NSString *aPubStreamId, EMError *aError)
     {
         if(!aError) {
             weakSekf.pubStreamId = aPubStreamId;
             [self->_delegates receiveSomeoneOnSpeaker:kCurrentUsername streamId:aPubStreamId mute:isMute];
         }
     }];
}

// 停止发布自己的流，并更新ui
- (void)setupMySelfToAudiance {
    [EMClient.sharedClient.conferenceManager
     unpublishConference:self.conference
     streamId:self.pubStreamId
     completion:^(EMError *aError) {
         
     }];
    [_delegates receiveSomeoneOffSpeaker:kCurrentUsername];
}


#pragma mark - admin
// 设置用户为主播
- (void)setupUserToSpeaker:(NSString *)aUsername {
    NSString *applyUid = [[EMClient sharedClient].conferenceManager getMemberNameWithAppkey:[EMClient sharedClient].options.appkey username:aUsername];
    [LRChatHelper.sharedInstance sendUserOnMicMsg:aUsername];
    [EMClient.sharedClient.conferenceManager
     changeMemberRoleWithConfId:self.conference.confId
     memberNames:@[applyUid] role:EMConferenceRoleSpeaker
     completion:^(EMError *aError) {
         
     }];
}

// 设置用户为听众
- (void)setupUserToAudiance:(NSString *)aUsername {
    NSString *applyUid = [[EMClient sharedClient].conferenceManager getMemberNameWithAppkey:[EMClient sharedClient].options.appkey username:aUsername];
    [LRChatHelper.sharedInstance sendUserOffMicMsg:aUsername];
    [EMClient.sharedClient.conferenceManager
     changeMemberRoleWithConfId:self.conference.confId
     memberNames:@[applyUid]
     role:EMConferenceRoleAudience
     completion:^(EMError *aError) {
         
     }];
}

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)aUsername {
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    body.isDeliverOnlineOnly = YES;
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aUsername
                                                          from:kCurrentUsername
                                                            to:aUsername
                                                          body:body
                                                           ext:@{kRequestAction:kRequestToBe_Rejected,
                                                                 kRequestConferenceId:self.conference.confId}];
    msg.chatType =  EMChatTypeChat;
    [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:nil];
}

- (void)setupSpeakerMicOn:(NSString *)aUsername {
    [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"talker" value:aUsername completion:nil];

}

- (void)setupSpeakerMicOff:(NSString *)aUsername {
    if (!self.roomModel) {
        return;
    }
    [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"talker" value:@"" completion:nil];
}

// 播放音乐
- (void)playMusic:(BOOL)isPlay {
    if (_isPlaying == isPlay) {
        return;
    }
    if (isPlay) {
        NSURL *url = [NSBundle.mainBundle URLForResource:@"music" withExtension:@"mp3"];
        EMError *error = [EMClient.sharedClient.conferenceManager startAudioMixing:url loop:-1];
        NSLog(@"error -- %@",error);
    } else {
        [EMClient.sharedClient.conferenceManager stopAudioMixing];
    }
    _isPlaying = isPlay;
}

#pragma mark - user
// 申请上麦
- (void)requestOnSpeaker:(LRRoomModel *)aRoom
              completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    
    if (self.conference.role == EMConferenceRoleSpeaker) {
        [self roleDidChanged:self.conference];
        return;
    }
    
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    body.isDeliverOnlineOnly = YES; // 只投递在线
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aRoom.owner
                                                          from:kCurrentUsername
                                                            to:aRoom.owner
                                                          body:body
                                                           ext:@{kRequestAction:kRequestToBe_Speaker,
                                                                 kRequestConferenceId:self.conference.confId}];
    
    msg.chatType = EMChatTypeChat;
    [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:^(EMMessage *message, EMError *error) {
        if (aCompletion) {
            if (!error) {aCompletion(nil, YES); return ;}
            aCompletion(error.errorDescription, NO);
        }
    }];
}

// 申请下麦
- (void)requestOffSpeaker:(LRRoomModel *)aRoom
               completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aRoom.owner
                                                          from:kCurrentUsername
                                                            to:aRoom.owner
                                                          body:body
                                                           ext:@{kRequestAction:kRequestToBe_Audience,
                                                                 kRequestConferenceId:self.conference.confId
                                                                 }];
    
    msg.chatType = EMChatTypeChat;
    [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:^(EMMessage *message, EMError *error) {
        if (aCompletion) {
            if (!error) {aCompletion(nil, YES); return ;}
            aCompletion(error.errorDescription, NO);
        }
    }];
}

// 是否静音自己
- (void)muteMyself:(BOOL)isMute {
    // 点亮或置灰自己在说话的亮点，因为操作自己时无法收到streamUpdate回调。
    [_delegates receiveSpeakerMute:kCurrentUsername mute:isMute];
    [EMClient.sharedClient.conferenceManager updateConference:self.conference isMute:isMute];
}

#pragma mark - argument mic
// 抢麦
- (void)argumentMic:(NSString *)aRoomId
         completion:(void(^)(NSString *errorInfo, BOOL success))aComplstion {
    NSString *url = [NSString stringWithFormat:@"http://turn2.easemob.com:8082/app/mic/%@/%@", aRoomId,kCurrentUsername];;
    __block BOOL success = NO;
    [LRRequestManager.sharedInstance requestWithMethod:@"GET"
                                             urlString:url
                                            parameters:nil
                                                 token:nil
                                            completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
     {
         success = [result[@"status"] boolValue];
         if (aComplstion) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (!error) {
                     aComplstion(nil, success);
                 }else {
                     aComplstion(nil, success);
                 }
             });
         }
     }];
}

// 释放麦
- (void)unArgumentMic:(NSString *)aRoomId
           completion:(void(^)(NSString *errorInfo, BOOL success))aComplstion {
    NSString *url = [NSString stringWithFormat:@"http://turn2.easemob.com:8082/app/discardmic/%@/%@", aRoomId,kCurrentUsername];;
    [LRRequestManager.sharedInstance requestWithMethod:@"DELETE"
                                             urlString:url
                                            parameters:nil
                                                 token:nil
                                            completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!error) {
                 if (aComplstion) {
                     aComplstion(nil, YES);
                 }
             }else {
                 if (aComplstion) {
                     aComplstion(nil, NO);
                 }
             }
         });
     }];
}

- (void)setAudioPlay:(BOOL)isPlay {
    // 设置会议属性
    if (isPlay) {
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"music" value:@"music.mpy" completion:nil];
    }else {
        [EMClient.sharedClient.conferenceManager deleteAttributeWithKey:@"music" completion:nil];
    }
}

#pragma mark - Monopoly Timer
- (void)updateMonopolyTimer {
    _time--;
    if (_time == 0) {
        [self stopMonopolyTimer];
        // 只有自己持有麦的时候才能释放麦
        if ([_currentMonopolyTalker isEqualToString:kCurrentUsername]) {
            [self setupSpeakerMicOff:kCurrentUsername];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LR_Remain_Speaking_timer_Notification object:@{@"currentSpeakingUsername":_currentMonopolyTalker,@"remainSpeakingTime":[NSNumber numberWithInt:_time]}];
}

// 启动倒计时
- (void)startMonopolyTimer {
    [self stopMonopolyTimer];
    _time = kKeepHandleTime;
    _monopolyTimer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(updateMonopolyTimer)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_monopolyTimer forMode:NSRunLoopCommonModes];
    [_monopolyTimer fire];
}

- (void)stopMonopolyTimer {
    if (_monopolyTimer) {
        [_monopolyTimer invalidate];
        _monopolyTimer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_Un_Argument_Speaker_Notification object:_currentMonopolyTalker];
    }
}


// 自动同意下麦申请
- (void)agreedToBeAudience:(NSNotification *)aNoti  {
    NSDictionary *dict = aNoti.object;
    NSString *username = dict[@"from"];
    NSString *confid = dict[@"confid"];
    if (!self.roomModel || ![confid isEqualToString:self.roomModel.conferenceId]) {
        return;
    }
    [self setupUserToAudiance:username];
}

#pragma mark - EMConferenceManagerDelegate

// 收到新的流发布，直接关注
- (void)streamDidUpdate:(EMCallConference *)aConference
              addStream:(EMCallStream *)aStream {
    // 判断是否是当前的Conference
    if (![aConference.confId isEqualToString:self.conference.confId]) {
        return;
    }
    
    [EMClient.sharedClient.conferenceManager subscribeConference:aConference
                                                        streamId:aStream.streamId
                                                 remoteVideoView:nil
                                                      completion:^(EMError *aError) {
                                                      }];
    
    [_delegates receiveSomeoneOnSpeaker:aStream.userName
                               streamId:aStream.streamId
                                   mute:!aStream.enableVoice];
}

// 收到流被移除，取消关注
- (void)streamDidUpdate:(EMCallConference *)aConference
           removeStream:(EMCallStream *)aStream {
    
    // 判断是否是当前的Conference
    if (![aConference.confId isEqualToString:aConference.confId]) {
        return;
    }

    [_delegates receiveSomeoneOffSpeaker:aStream.userName];
}

// 收到流数据更新（这个项目里只有mute的操作），上报到上层
- (void)streamDidUpdate:(EMCallConference *)aConference stream:(EMCallStream *)aStream {
    // 判断是否是当前的Conference
    if (![aConference.confId isEqualToString:aConference.confId]) {
        return;
    }
    [_delegates receiveSpeakerMute:aStream.userName mute:!aStream.enableVoice];
}

// 管理员设置你上麦后会收到该回调
- (void)roleDidChanged:(EMCallConference *)aConference {
    if (aConference.role == EMConferenceRoleSpeaker) // 被设置为主播
    {
        [self setupMySelfToSpeaker];
        [NSNotificationCenter.defaultCenter postNotificationName:LR_UI_ChangeRoleToSpeaker_Notification
                                                          object:nil];
    }
    else if (aConference.role == EMConferenceRoleAudience) // 被设置为观众
    {
        [self setupMySelfToAudiance];
        [NSNotificationCenter.defaultCenter postNotificationName:LR_UI_ChangeRoleToAudience_Notification
                                                          object:nil];
        if ([_currentMonopolyTalker isEqualToString:kCurrentUsername]) {
            [self unArgumentMic:self.roomModel.roomId
                     completion:^(NSString * _Nonnull errorInfo, BOOL success)
             {
                 [self setupSpeakerMicOff:kCurrentUsername];
             }];
        }
    }
}

// 监听销毁，退出房间
- (void)conferenceDidEnd:(EMCallConference *)aConference
                  reason:(EMCallEndReason)aReason
                   error:(EMError *)aError {
    if (![aConference.confId isEqualToString:self.roomModel.conferenceId]) {
        return;
    }
    [NSNotificationCenter.defaultCenter postNotificationName:LR_Receive_Conference_Destory_Notification
                                                      object:aConference.confId];
}

// 监听用户说话
- (void)conferenceSpeakerDidChange:(EMCallConference *)aConference
                 speakingStreamIds:(NSArray *)aStreamIds {
    [NSNotificationCenter.defaultCenter postNotificationName:LR_Stream_Did_Speaking_Notification
                                                      object:aStreamIds];
}


// 会议属性修改
- (void)conferenceAttributeUpdated:(EMCallConference *)aConference
                        attributes:(NSArray <EMConferenceAttribute *>*)attrs{
    NSString *talker = nil;
    BOOL isPlay = NO;
    for (EMConferenceAttribute *attr in attrs) {
        NSLog(@"attr.key -- %@  value -- %@",attr.key, attr.value);
        if ([attr.key isEqualToString:@"type"]) {
            NSString *roomType = attr.value;
            if ([roomType isEqualToString:@"communication"]) {
                self.roomModel.roomType = LRRoomType_Communication;
            }else if ([roomType isEqualToString:@"host"]) {
                self.roomModel.roomType = LRRoomType_Host;
            }else if ([roomType isEqualToString:@"monopoly"]) {
                self.roomModel.roomType = LRRoomType_Monopoly;
            }
            [_delegates roomTypeDidChange:self.roomModel.roomType];
        }
        if ([attr.key isEqualToString:@"talker"]) {
            talker = attr.value;
        }
        
        if ([attr.key isEqualToString:@"music"]) {
            isPlay = attr.action == EMConferenceAttributeAdd ? YES : NO;
        }
    }
    
    
    if (talker) {
        if (self.roomModel.roomType == LRRoomType_Host) {
            [_delegates currentHostTypeSpeakerChanged:talker];
        }
        if (self.roomModel.roomType == LRRoomType_Monopoly) {
            _currentMonopolyTalker = talker;
            if ([_currentMonopolyTalker isEqualToString:@""]) {
                [self stopMonopolyTimer];
            }else {
                [self startMonopolyTimer];
            }
            [_delegates currentMonopolyTypeSpeakerChanged:_currentMonopolyTalker];
        }
    }
    
    [self playMusic:isPlay];
    
}

#pragma mark - getter
- (NSString *)adminId {
    return self.conference.adminIds.firstObject;
}

- (BOOL)hasHeadset {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];
    for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
        if ([[output portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

// 设置音频输出端
- (void)loudspeaker {
    if ([self hasHeadset]) {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason   = [[interuptionDict
                                      valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
    }
}


@end
