//
//  LRSpeakHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTypes.h"

NS_ASSUME_NONNULL_BEGIN



@protocol LRSpeakHelperDelegate <NSObject>

@optional
// 收到有人上麦
- (void)receiveSomeoneOnSpeaker:(NSString *)aUsername mute:(BOOL)isMute;

// 收到有人下麦
- (void)receiveSomeoneOffSpeaker:(NSString *)aUsername;

// 收到成员静音状态变化
- (void)receiveSpeakerMute:(NSString *)aUsername
                      mute:(BOOL)isMute;

// 房间属性变化
- (void)roomTypeDidChange:(LRRoomType)aType;

// 谁在说话回调 (在主持或者抢麦模式下，标注谁在说话)
- (void)currentSpeaker:(NSString *)aSpeaker;

@end

@class LRRoomModel;
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
- (void)setupMySelfToSpeaker;

// 自己下麦
- (void)setupMySelfToAudiance;

// 设置用户角色为主播(群主设置Speaker上麦时使用)
- (void)setupUserToSpeaker:(NSString *)aUsername;

// 设置用户角色为观众(群主设置Speaker下麦时使用)
- (void)setupUserToAudiance:(NSString *)aUsername;

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)aUsername;

#pragma mark - user
// 申请上麦
- (void)requestOnSpeaker:(LRRoomModel *)aRoom
            completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 申请下麦
- (void)requestOffSpeaker:(LRRoomModel *)aRoom
             completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 是否静音自己
- (void)muteMyself:(BOOL)isMute;

@end

NS_ASSUME_NONNULL_END
