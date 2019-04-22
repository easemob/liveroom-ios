//
//  LRSpeakHelper.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakHelper.h"
#import "LRGCDMulticastDelegate.h"

@interface LRSpeakHelper () <EMConferenceManagerDelegate>
{
    LRGCDMulticastDelegate <LRSpeakHelperDelegate> *_delegates;
}

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
- (void)joinSpeakRoomWithRoomId:(NSString *)aRoomId
                       password:(NSString *)aPassword
                     completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.conferenceManager joinConferenceWithConfId:aRoomId
                                                             password:aPassword
                                                           completion:^(EMCallConference *aCall, EMError *aError)
    {
        if (!aError) { weakSelf.conference = aCall; }
        if (aCompletion) {
            aCompletion(aError.errorDescription, !aError);
        }
    }];
}

// 离开语音会议
- (void)leaveSpeakRoomWithRoomId:(NSString *)aRoomId
                      completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [EMClient.sharedClient.conferenceManager leaveConference:self.conference
                                                  completion:^(EMError *aError)
    {
        if (aCompletion) {
            aCompletion(aError.errorDescription, !aError);
        }
    }];
}

#pragma mark - admin
- (void)setupOnSpeaker {
    EMStreamParam *param = [[EMStreamParam alloc] init];
    param.streamName = kCurrentUsername;
    param.enableVideo = NO;
    param.isMute = NO;
    [EMClient.sharedClient.conferenceManager publishConference:self.conference
                                                   streamParam:param
                                                    completion:^(NSString *aPubStreamId, EMError *aError)
     {
        
    }];
}

- (void)setupUserToAudiance:(NSString *)aUsername{
    [EMClient.sharedClient.conferenceManager changeMemberRoleWithConfId:self.conference.confId
                                                            memberNames:@[aUsername]
                                                                   role:EMConferenceRoleAudience
                                                             completion:nil];
}

// 同意用户上麦申请
- (void)acceptUserOnSpeaker:(NSString *)aUsername
                   chatroom:(NSString *)aChatroomId {
    [EMClient.sharedClient.conferenceManager
     changeMemberRoleWithConfId:self.conference.confId
     memberNames:@[aUsername] role:EMConferenceRoleSpeaker
     completion:nil];
    [_delegates receiveSomeoneOnSpeaker:aUsername mute:YES];
}

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)aUsername
                   chatroom:(NSString *)aChatroomId {
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aChatroomId
                                                          from:kCurrentUsername
                                                            to:aChatroomId
                                                          body:body
                                                           ext:@{kRequestKey:kRequestToBe_Rejected}];
    msg.chatType =  EMChatTypeChatRoom;
    [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:nil];
}

#pragma mark - user
// 申请上麦
- (void)applyOnSpeaker:(NSString *)aChatroomId
            completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@""];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:aChatroomId
                                                          from:kCurrentUsername
                                                            to:aChatroomId
                                                          body:body
                                                           ext:@{kRequestKey:kRequestToBe_Speaker}];
    
    msg.chatType = EMChatTypeChatRoom;
    [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:^(EMMessage *message, EMError *error) {
        if (aCompletion) {
            if (!error) {aCompletion(nil, YES); return ;}
            aCompletion(error.errorDescription, NO);
        }
    }];
}

// 申请下麦
- (void)applyOffSpeaker:(NSString *)aChatroomId
             completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    
}

// 是否静音自己
- (void)muteMyself:(BOOL)isMute {
    
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
                                                      completion:nil];
    
    [_delegates receiveSomeoneOnSpeaker:aStream.userName mute:!aStream.enableVoice];
}

// 收到流被移除，取消关注
- (void)streamDidUpdate:(EMCallConference *)aConference
           removeStream:(EMCallStream *)aStream {
    
    // 判断是否是当前的Conference
    if (![aConference.confId isEqualToString:aConference.confId]) {
        return;
    }
    
    
    [EMClient.sharedClient.conferenceManager unsubscribeConference:aConference
                                                          streamId:aStream.streamId
                                                        completion:nil];
    
    [_delegates receiveSomeoneOffSpeaker:aStream.userName];
}

// 收到流数据更新（这个项目里只有mute的操作），上报到上层
- (void)streamDidUpdate:(EMCallConference *)aConference stream:(EMCallStream *)aStream {
    // 判断是否是当前的Conference
    if (![aConference.confId isEqualToString:aConference.confId]) {
        return;
    }
    [_delegates receiveSpeakerMute:aStream.userName mute:aStream.enableVoice];
}

- (void)memberDidJoin:(EMCallConference *)aConference
               member:(EMCallMember *)aMember
{
    
}

- (void)memberDidLeave:(EMCallConference *)aConference
                member:(EMCallMember *)aMember
{
    
}

#pragma mark - getter
- (NSString *)adminId {
    return self.conference.adminIds.firstObject;
}

@end
