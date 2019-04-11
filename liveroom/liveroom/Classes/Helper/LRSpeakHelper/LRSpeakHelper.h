//
//  LRSpeakHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSpeakHelper : NSObject
+ (LRSpeakHelper *)sharedInstance;

// 加入语音会议
- (void)joinSpeakRoomWithRoomId:(NSString *)aRoomId
                       password:(NSString *)aPassword
                     completion:(void(^)(NSString *errorInfo, BOOL success))aCompletion;

// 离开语音会议
- (void)leaveSpeakRoomWithRoomId:(NSString *)aRoomId;

@end

NS_ASSUME_NONNULL_END
