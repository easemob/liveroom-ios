//
//  LRChatHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRChatHelperDelegate <NSObject>
@optional
- (void)didReceiveRoomMessageWithRoomId:(NSString *)aChatroomId
                                message:(NSString *)aMessage
                               fromUser:(NSString *)fromUser
                              timestamp:(long long)aTimestamp;

- (void)didReceiveRoomLikeActionWithRoomId:(NSString *)aChatroomId;

- (void)didReceiveRoomGiftActionWithRoomId:(NSString *)aChatroomId;
@end

@interface LRChatHelper : NSObject

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, strong, readonly) NSString *currentUser;

+ (LRChatHelper *)sharedInstance;

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
- (void)joinChatroomWithRoomId:(NSString *)aChatroomId
                    completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)leaveChatroomWithRoomId:(NSString *)aChatroomId
                     completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

#pragma mark - message
- (void)sendMessageToChatroom:(NSString *)aChatroomId
                      message:(NSString *)aMessage
         completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;


- (void)sendLikeToChatroom:(NSString *)aChatroomId
                completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;

- (void)sendGiftToChatroom:(NSString *)aChatroomId
                completion:(void(^ _Nullable)(NSString *errorInfo, BOOL success))aCompletion;



@end

NS_ASSUME_NONNULL_END
