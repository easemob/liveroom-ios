//
//  LRChatHelper.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRChatHelper.h"
#import "LRGCDMulticastDelegate.h"
#import "Headers.h"
#import "LRRoomModel.h"

@interface LRChatHelper () <EMChatManagerDelegate, EMChatroomManagerDelegate, EMClientDelegate>
{
    LRGCDMulticastDelegate <LRChatHelperDelegate> *_delegates;
}
@end

@implementation LRChatHelper
+ (LRChatHelper *)sharedInstance {
    static LRChatHelper *helper_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper_ = [[LRChatHelper alloc] init];
    });
    return helper_;
}

- (instancetype)init {
    if (self = [super init]) {
        _delegates = (LRGCDMulticastDelegate<LRChatHelperDelegate> *)[[LRGCDMulticastDelegate alloc] init];
        [self registerImSDK];
        [self _registerIMDelegates];
    }
    return self;
}

#pragma mark - private
- (EMOptions *)registerImSDK {
    // 1100181024084247#voicechatroom
    EMOptions *options = [EMOptions optionsWithAppkey:@"1100181023201864#voicechatroom"];
    options.enableDnsConfig = NO;
    options.chatPort = 6717;
    options.chatServer = @"39.107.54.56";
    options.restServer = @"a1-hsb.easemob.com";
    options.enableConsoleLog = YES;
    [EMClient.sharedClient initializeSDKWithOptions:options];
    return options;
}

#pragma mark - getter
- (BOOL)isLoggedIn {
    return EMClient.sharedClient.isAutoLogin;
}

- (NSString *)currentUser {
    return EMClient.sharedClient.currentUsername;
}

#pragma mark register delegates
- (void)_registerIMDelegates {
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    [EMClient.sharedClient.roomManager addDelegate:self delegateQueue:nil];
}

- (void)addDeelgate:(id<LRChatHelperDelegate>)aDelegate delegateQueue:(dispatch_queue_t)aQueue {
    if (!aQueue) {
        aQueue = dispatch_get_main_queue();
    }
    [_delegates addDelegate:aDelegate delegateQueue:aQueue];
}

- (void)removeDelegate:(id<LRChatHelperDelegate>)aDelegate {
    [_delegates removeDelegate:aDelegate];
}

#pragma mark - account
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                    completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [EMClient.sharedClient loginWithUsername:aUsername
                                    password:aPassword
                                  completion:^(NSString *aUsername, EMError *aError)
     {
         if (!aError) { [[EMClient sharedClient].options setIsAutoLogin:YES]; }
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}

- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                       completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [EMClient.sharedClient registerWithUsername:aUsername
                                       password:aPassword
                                     completion:^(NSString *aUsername, EMError *aError)
     {
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}
#pragma mark - chatroom
- (void)joinChatroomWithCompletion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [EMClient.sharedClient.roomManager joinChatroom:_roomModel.roomId
                                         completion:^(EMChatroom *aChatroom, EMError *aError)
     {
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}

- (void)leaveChatroomWithCompletion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [EMClient.sharedClient.roomManager leaveChatroom:_roomModel.roomId
                                          completion:^(EMError *aError)
     {
         if (aCompletion) {
             aCompletion(aError.errorDescription, !aError);
         }
     }];
}

#pragma mark - message
- (void)sendMessage:(NSString *)aMessage
                   completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:aMessage];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:_roomModel.roomId
                                                          from:EMClient.sharedClient.currentUsername
                                                            to:_roomModel.roomId
                                                          body:body
                                                           ext:nil];
    msg.chatType = EMChatTypeChatRoom;
    [EMClient.sharedClient.chatManager sendMessage:msg
                                          progress:nil
                                        completion:^(EMMessage *message, EMError *error)
    {
        if (aCompletion) {
            aCompletion(error.errorDescription, !error);
        }
    }];
}

- (void)sendLikeMessage:(NSString *)aMessage
                completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [self sendMessage:aMessage completion:aCompletion];
}

- (void)sendGiftMessage:(NSString *)aMessage
                completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    [self sendMessage:aMessage completion:aCompletion];
}

- (void)sendMessageFromNoti:(NSString *)aMsg {
    [[NSNotificationCenter defaultCenter] postNotificationName:LR_Send_Messages_Notification object:aMsg];
}

- (void)sendUserOnMicMsg:(NSString *)username {
    [self sendMessageFromNoti:[NSString stringWithFormat:@"[@%@]上麦",username]];
}

- (void)sendUserOffMicMsg:(NSString *)username{
    [self sendMessageFromNoti:[NSString stringWithFormat:@"[@%@]下麦",username]];
}

#pragma mark - EMChatManagerDelegate
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *msg in aCmdMessages) {
        NSString *action = msg.ext[kRequestAction];
        NSString *confid = msg.ext[kRequestConferenceId];
       
        if ([action isEqualToString:kRequestToBe_Speaker]) // 收到上麦申请
        {
            [NSNotificationCenter.defaultCenter postNotificationName:LR_Receive_OnSpeak_Request_Notification
                                                              object:@{@"from":msg.from,@"confid":confid}];
        }
        
        if ([action isEqualToString:kRequestToBe_Rejected]) // 收到拒绝上麦事件
        {
            [NSNotificationCenter.defaultCenter postNotificationName:LR_Receive_OnSpeak_Reject_Notification
                                                              object:@{@"from":msg.from,@"confid":confid}];
        }
        
        if ([action isEqualToString:kRequestToBe_Audience]) // 收到下麦事件
        {
            [NSNotificationCenter.defaultCenter postNotificationName:LR_Receive_ToBe_Audience_Notification
                                                              object:@{@"from":msg.from,@"confid":confid}];
        }
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages {

    for (EMMessage *msg in aMessages) {
        if (msg.chatType != EMChatTypeChatRoom) {
            continue;
        }
        
        if (msg.body.type != EMMessageBodyTypeText) {
            continue;
        }
        BOOL isLike = NO;
        if (isLike) {
            [_delegates didReceiveRoomLikeActionWithRoomId:msg.conversationId];
            continue;
        }
        
        
        BOOL isGift = NO;
        if (isGift) {
            [_delegates didReceiveRoomGiftActionWithRoomId:msg.conversationId];
            continue;
        }
        
        NSString *msgInfo = ((EMTextMessageBody *)[msg body]).text;
        [_delegates didReceiveRoomMessageWithRoomId:msg.conversationId
                                            message:msgInfo
                                           fromUser:msg.from
                                          timestamp:msg.timestamp];
    }
}

- (void)dealloc {
    
}

@end
