//
//  LRSpeakHelperDelegate.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

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

NS_ASSUME_NONNULL_END
