//
//  LRImHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRImHelperDelegate <NSObject>
- (void)didReceiveRoomMessageWithRoomId:(NSString *)aChatroomId
                                message:(NSString *)aMessage
                               fromUser:(NSString *)fromUser
                              timestamp:(long long)aTimestamp;

- (void)didReceiveRoomLikeActionWithRoomId:(NSString *)aChatroomId;

- (void)didReceiveRoomGiftActionWithRoomId:(NSString *)aChatroomId;
@end

@interface LRImHelper : NSObject

@property (nonatomic, readonly) BOOL isLoggedIn;

+ (LRImHelper *)sharedInstance;

- (void)addDeelgate:(id<LRImHelperDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

- (void)removeDelegate:(id<LRImHelperDelegate>)aDelegate;

#pragma mark - account
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                    completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                       completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - chatroom
- (void)joinChatroomWithRoomId:(NSString *)aChatroomId
                    completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

- (void)leaveChatroomWithRoomId:(NSString *)aChatroomId
                     completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - message
- (void)sendMessageToChatroom:(NSString *)aChatroomId
                      message:(NSString *)aMessage
         completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;


- (void)sendLikeToChatroom:(NSString *)aChatroomId
                completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

- (void)sendGiftToChatroom:(NSString *)aChatroomId
                completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;
@end

NS_ASSUME_NONNULL_END
