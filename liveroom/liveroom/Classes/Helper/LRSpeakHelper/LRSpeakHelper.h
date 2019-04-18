//
//  LRSpeakHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LRSpeakerRole_Speaker,
    LRSpeakerRole_Audience,
} LRSpeakerRole;

@protocol LRSpeakHelperDelegate <NSObject>

@optional
// 收到有人上麦
- (void)receiveSomeoneOnSpeaker:(NSString *)aUsername mute:(BOOL)isMute;

// 收到有人下麦
- (void)receiveSomeoneOffSpeaker:(NSString *)aUsername;

// 收到成员静音状态变化
- (void)receiveSpeakerMute:(NSString *)aUsername
                      mute:(BOOL)isMute;

@end

@interface LRSpeakHelper : NSObject
@property (nonatomic, strong) NSString *adminId;
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
// 自己上麦
- (void)setupOnSpeaker;

// 设置用户角色为观众(Speaker下麦时使用)
- (void)setupUserToAudiance:(NSString *)aUsername;

// 同意用户上麦申请
- (void)acceptUserOnSpeaker:(NSString *)aUsername
                   chatroom:(NSString *)aChatroomId;

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)aUsername
                   chatroom:(NSString *)aChatroomId;

#pragma mark - user
// 申请上麦
- (void)applyOnSpeaker:(NSString *)aChatroomId
            completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 申请下麦
- (void)applyOffSpeaker:(NSString *)aChatroomId
             completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 是否静音自己
- (void)muteMyself:(BOOL)isMute;

@end

NS_ASSUME_NONNULL_END
