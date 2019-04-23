//
//  LRChatHelperDelegate.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
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
NS_ASSUME_NONNULL_END
