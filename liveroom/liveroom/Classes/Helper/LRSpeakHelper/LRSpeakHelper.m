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
#import "LRSpeakerPentakillController.h"
#import "LRSpeakerPentakillCell.h"

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
/*
static NSString *identity = @"";//全局static狼人杀模式身份标识
static NSString *clockStatus;  //时钟状态

+ (NSString *)instanceIdentity {
    return identity;
}
+ (void)setupIdentity:(NSString *)status {
    identity = status;
}

+ (NSString *)instanceClockStatus {
    return clockStatus;
}
+ (void)setupClockStatus:(NSString *)clock {
    clockStatus = clock;
}*/

static dispatch_once_t onceToken;
static LRSpeakHelper *helper_;
- (NSMutableArray *)identityDic {
    if(!_identityDic){
        _identityDic = [[NSMutableArray alloc]init];
    }
    return _identityDic;
}
+ (LRSpeakHelper *)sharedInstance {
    dispatch_once(&onceToken, ^{
        helper_ = [[LRSpeakHelper alloc] init];
    });
    return helper_;
}
- (void)destoryInstance {
    onceToken = 0;
    helper_ = nil;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
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

// 发布自己的流，并更新ui
- (void)setupMySelfToSpeaker {
    __weak typeof(self) weakSekf = self;
    EMStreamParam *param = [[EMStreamParam alloc] init];
    param.streamName = kCurrentUsername;
    param.enableVideo = NO;
    // 如果是自由麦模式 主播模式(群主)，上麦可以直接说话
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
- (void)setupUserToSpeaker:(NSString *)aUsername
                completion:(void(^)(BOOL success, NSString *username))completion
{
    NSString *applyUid = [[EMClient sharedClient].conferenceManager
                          getMemberNameWithAppkey:[EMClient sharedClient].options.appkey
                          username:aUsername];
    [LRChatHelper.sharedInstance sendUserOnMicMsg:aUsername];
    [EMClient.sharedClient.conferenceManager changeMemberRoleWithConfId:self.conference.confId
                                                            memberNames:@[applyUid]
                                                                   role:EMConferenceRoleSpeaker
                                                             completion:^(EMError *aError)
     {
         if (completion) {
             completion(aError ? NO : YES, applyUid);
         }
     }];
}

// 设置用户为听众
- (void)setupUserToAudiance:(NSString *)aUsername {
    
    if((LRSpeakHelper.sharedInstance.identityDic != nil) && [LRSpeakHelper.sharedInstance.identityDic containsObject:aUsername]){
        //把当前要下麦（主动/被动）主播从狼人主播数组删除
        for (NSString *str in LRSpeakHelper.sharedInstance.identityDic) {
            NSLog(@"\n---------->userprevious:    %@",str);
        }
        [LRSpeakHelper.sharedInstance.identityDic removeObject:aUsername];
        for (NSString *str in LRSpeakHelper.sharedInstance.identityDic) {
            NSLog(@"\n---------->userofflineend:    %@",str);
        }
        NSString *str = [LRSpeakHelper.sharedInstance.identityDic componentsJoinedByString:@","];
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"identityDic" value:str completion:^(EMError *aError){}];
    }
    
    NSString *applyUid = [[EMClient sharedClient].conferenceManager getMemberNameWithAppkey:[EMClient sharedClient].options.appkey username:aUsername];
    [LRChatHelper.sharedInstance sendUserOffMicMsg:aUsername];
    [EMClient.sharedClient.conferenceManager
     changeMemberRoleWithConfId:self.conference.confId
     memberNames:@[applyUid]
     role:EMConferenceRoleAudience
     completion:^(EMError *aError) {
         
     }];
    
    //狼人杀模式通知下麦主播事件
    if(self.roomModel.roomType == LRRoomType_Pentakill){
        EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
        EMMessage *msg = [[EMMessage alloc] initWithConversationID:aUsername
                                                              from:kCurrentUsername
                                                                to:aUsername
                                                              body:body
                                                               ext:@{kRequestAction:kRequestToBe_Audience,
                                                                kRequestConferenceId:self.conference.confId,
                                                                     }];
        msg.chatType = EMChatTypeChat;
        [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:^(EMMessage *message, EMError *error) {
        }];
    }
    
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
        EMError *error = [EMClient.sharedClient.conferenceManager startAudioMixing:url loop:-1 sendMix:NO];
        [EMClient.sharedClient.conferenceManager adjustAudioMixingVolume:30];
        [self loudspeaker];
        NSLog(@"error -- %@",error);
    } else {
        [EMClient.sharedClient.conferenceManager stopAudioMixing];
    }
    _isPlaying = isPlay;
}


#pragma mark - user
// 申请上麦
- (void)requestOnSpeaker:(LRRoomModel *)aRoom identity:(NSString *)identity
              completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    
    if (self.conference.role == EMConferenceRoleSpeaker) {
        [self roleDidChanged:self.conference];
        return;
    }
    
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    body.isDeliverOnlineOnly = YES; // 只投递在线
    NSDictionary *extArry = @{kRequestAction:kRequestToBe_Speaker,
                              kRequestConferenceId:self.conference.confId
                              };
    if([identity isEqualToString:@"pentakill"]){
        extArry = @{kRequestAction:kRequestToBe_Speaker,
                    kRequestConferenceId:self.conference.confId,
                    kRequestUserIdentity:@"pentakill"
                    };
    }
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aRoom.owner
                                                          from:kCurrentUsername
                                                            to:aRoom.owner
                                                          body:body
                                                           ext:extArry];
    
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
                                                                 kRequestConferenceId:self.conference.confId,
                                                                 }];
    
    //这里不用做狼人杀身份重置，在下麦的时候有一个房主发出的通知，接收通知出有重置
    
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
    NSString *url = [NSString stringWithFormat:@"http://tcapp.easemob.com/app/mic/%@/%@", aRoomId,kCurrentUsername];;
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
    NSString *url = [NSString stringWithFormat:@"http://tcapp.easemob.com/app/discardmic/%@/%@", aRoomId,kCurrentUsername];;
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
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"music" value:@"music.mp3" completion:nil];
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
    if([self.roomModel.owner isEqualToString:kCurrentUsername]){
        NSDictionary *dict = aNoti.object;
        NSString *username = dict[@"from"];
        NSString *confid = dict[@"confid"];
        if (!self.roomModel || ![confid isEqualToString:self.roomModel.conferenceId]) {
            return;
        }
        [self setupUserToAudiance:username];
    }
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
                                                      completion:^(EMError *aError)
     {
         [self loudspeaker];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_UI_ChangeRoleToSpeaker_Notification
                                                            object:nil];
    }
    else if (aConference.role == EMConferenceRoleAudience) // 被设置为观众
    {
        [self setupMySelfToAudiance];
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_UI_ChangeRoleToAudience_Notification
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
    [[NSNotificationCenter defaultCenter] postNotificationName:LR_Receive_Conference_Destory_Notification
                                                        object:aConference.confId];
}

// 监听用户说话
- (void)conferenceSpeakerDidChange:(EMCallConference *)aConference
                 speakingStreamIds:(NSArray *)aStreamIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:LR_Stream_Did_Speaking_Notification
                                                        object:aStreamIds];
}


// 会议属性修改
- (void)conferenceAttributeUpdated:(EMCallConference *)aConference
                        attributes:(NSArray <EMConferenceAttribute *>*)attrs{
    NSString *talker = nil;
    for (EMConferenceAttribute *attr in attrs) {
        /*
         if ([attr.key isEqualToString:@"type"]) {
         NSString *roomType = attr.value;
         if ([roomType isEqualToString:@"communication"]) {
         self.roomModel.roomType = LRRoomType_Communication;
         }else if ([roomType isEqualToString:@"host"]) {
         self.roomModel.roomType = LRRoomType_Host;
         }else if ([roomType isEqualToString:@"monopoly"]) {
         self.roomModel.roomType = LRRoomType_Monopoly;
         }else if ([roomType isEqualToString:@"pentakill"]){
         self.roomModel.roomType = LRRoomType_Pentakill;
         }
         [_delegates roomTypeDidChange:self.roomModel.roomType];
         }
         */
        //狼人杀模式当前房间时钟状态
        if([attr.key isEqualToString:@"clockStatus"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:LR_CLOCK_STATE_CHANGE object:attr.value];
        }
        
        //狼人杀模式主播身份数组
        if([attr.key isEqualToString:@"identityDic"]){
            LRSpeakHelper.sharedInstance.identityDic = [NSMutableArray arrayWithArray:[attr.value componentsSeparatedByString:@","]];
            [[NSNotificationCenter defaultCenter] postNotificationName:LR_WEREWOLF_DIDCHANGE
                                                                object:nil];
        }
        
        if ([attr.key isEqualToString:@"talker"]) {
            talker = attr.value;
        }
        
        if ([attr.key isEqualToString:@"music"]) {
            if (attr.action == EMConferenceAttributeAdd) {
                [self playMusic:YES];
            }else if (attr.action == EMConferenceAttributeDelete) {
                [self playMusic:NO];
            }
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
    NSError *error = nil;
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    //是否有耳机插入
    if (![self hasHeadset]) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    [audioSession setActive:YES error:&error];
    
}

- (void)audioRouteChangeListenerCallback:(NSNotification *)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
        default:
            break;
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


@end
