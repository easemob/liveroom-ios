//
//  LRChatHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRChatHelperDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@class LRRoomModel;
@interface LRChatHelper : NSObject

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, strong, readonly) NSString *currentUser;
@property (nonatomic, weak) LRRoomModel * _Nullable roomModel;

+ (LRChatHelper *)sharedInstance;
- (EMOptions *)registerImSDK;
- (void)addDeelgate:(id<LRChatHelperDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t  _Nullable)aQueue;

- (void)removeDelegate:(id<LRChatHelperDelegate>)aDelegate;

#pragma mark - account
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                    completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                       completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - chatroom
- (void)joinChatroomWithCompletion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)leaveChatroomWithCompletion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - message
- (void)sendMessage:(NSString *)aMessage
         completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)sendLikeMessage:(NSString *)aMessage
                    completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)sendGiftMessage:(NSString *)aMessage
                completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)sendMessageFromNoti:(NSString *)aMsg;

- (void)sendUserOnMicMsg:(NSString *)username;

- (void)sendUserOffMicMsg:(NSString *)username;

@end

NS_ASSUME_NONNULL_END
