//
//  LRSpeakHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LRSpeakHelperDelegate <NSObject>

@optional
// 收到上麦申请
- (void)onSperkRequestDidReceive:(NSString *)aUsername
                        chatroom:(NSString *)aChatroomId;

// 收到有人上麦
- (void)receiveSomeoneOnSpeaker:(NSString *)aUsername;

// 收到有人下麦
- (void)receiveSomeoneOffSpeaker:(NSString *)aUsername;

// 收到成员静音状态变化
- (void)receiveSpeakerMute:(NSString *)aUsername
                      mute:(BOOL)isMute;
@end

@interface LRSpeakHelper : NSObject
+ (LRSpeakHelper *)sharedInstance;

- (void)addDeelgate:(id<LRSpeakHelperDelegate>)aDelegate delegateQueue:(dispatch_queue_t _Nullable)aQueue;

- (void)removeDelegate:(id<LRSpeakHelperDelegate>)aDelegate;

// 加入语音会议
- (void)joinSpeakRoomWithRoomId:(NSString *)aRoomId
                       password:(NSString *)aPassword
                     completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

// 离开语音会议
- (void)leaveSpeakRoomWithRoomId:(NSString *)aRoomId
                      completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - admin
// 同意用户上麦申请
- (void)acceptUserOnSpeaker:(NSString *)username
                   chatroom:(NSString *)aChatroomId;

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)username
                   chatroom:(NSString *)aChatroomId;

#pragma mark - user
// 申请上麦
- (void)applyOnSpeaker:(NSString *)aChatroom
            completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 申请下麦
- (void)applyOffSpeaker:(NSString *)aChatroom
             completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 是否静音自己
- (void)muteMyself:(BOOL)isMute;

@end

NS_ASSUME_NONNULL_END
