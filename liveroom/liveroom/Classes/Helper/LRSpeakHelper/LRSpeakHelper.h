//
//  LRSpeakHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTypes.h"
#import "LRSpeakHelperDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class LRRoomModel;
@interface LRSpeakHelper : NSObject
@property (nonatomic, strong) EMCallConference *conference;
@property (nonatomic, weak) LRRoomModel * _Nullable roomModel;
@property (nonatomic, strong) NSMutableArray *identityDic;  //当前房间狼人数组

+ (NSString *)instanceIdentity;//返回狼人杀主播身份
+ (void)setupIdentity:(NSString *)status;//设置狼人杀主播身份
+ (NSString *)instanceClockStatus;//返回狼人杀时钟状态
+ (void)setupClockStatus:(NSString *)clock;//设置狼人杀时钟状态

- (void)destoryInstance;//销毁单例
+ (LRSpeakHelper *)sharedInstance;

- (void)addDeelgate:(id<LRSpeakHelperDelegate>)aDelegate delegateQueue:(dispatch_queue_t _Nullable)aQueue;

- (void)removeDelegate:(id<LRSpeakHelperDelegate>)aDelegate;

// 加入语音会议
- (void)joinSpeakRoomWithConferenceId:(NSString *)aRoomId
                             password:(NSString *)aPassword
                           completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

// 离开语音会议
- (void)leaveSpeakRoomWithRoomId:(NSString *)aRoomId
                      completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - admin
// 设置房间属性
//- (void)setupRoomType:(LRRoomType)aType;

// 自己上麦
- (void)setupMySelfToSpeaker;

// 自己下麦
- (void)setupMySelfToAudiance;

// 设置用户角色为主播(群主设置Speaker上麦时使用)
- (void)setupUserToSpeaker:(NSString *)aUsername
                completion:(void(^)(BOOL success, NSString *username))completion;

// 设置用户角色为观众(群主设置Speaker下麦时使用)
- (void)setupUserToAudiance:(NSString *)aUsername;

// 拒绝用户上麦申请
- (void)forbidUserOnSpeaker:(NSString *)aUsername;

// 指定用户发言(主持模式, 抢麦模式)
- (void)setupSpeakerMicOn:(NSString *)aUsername;

// 取消用户发言(主持模式, 抢麦模式)
- (void)setupSpeakerMicOff:(NSString *)aUsername;

#pragma mark - user
// 申请上麦
- (void)requestOnSpeaker:(LRRoomModel *)aRoom identity:(NSString *)identity
              completion:(void(^_Nullable)(NSString *errorInfo, BOOL success))aCompletion;

// 申请下麦
- (void)requestOffSpeaker:(LRRoomModel *)aRoom
               completion:(void (^)(NSString *errorInfo, BOOL success))aCompletion;

// 是否静音自己
- (void)muteMyself:(BOOL)isMute;


#pragma mark - argument mic
// 抢麦
- (void)argumentMic:(NSString *)aRoomId
         completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aComplstion;

// 释放麦
- (void)unArgumentMic:(NSString *)aRoomId
           completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aComplstion;

// 播放音乐(只有群主可以操作)
- (void)setAudioPlay:(BOOL)isPlay;

@end


NS_ASSUME_NONNULL_END
