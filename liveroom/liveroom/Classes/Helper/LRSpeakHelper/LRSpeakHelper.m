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
@property (nonatomic, strong) EMCallConference *conference;

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
// 同意用户上麦申请
- (void)acceptUserOnSpeaker:(NSString *)username
                   chatroom:(NSString *)aChatroomId {
    
}

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)username
                   chatroom:(NSString *)aChatroomId {
    
}

#pragma mark - user
// 申请上麦
- (void)applyOnSpeaker:(NSString *)aChatroom
            completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    
}

// 申请下麦
- (void)applyOffSpeaker:(NSString *)aChatroom
             completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion {
    
}

// 是否静音自己
- (void)muteMyself:(BOOL)isMute {
    
}

@end
