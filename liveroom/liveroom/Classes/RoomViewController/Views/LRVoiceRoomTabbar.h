//
//  LRVoiceRoomTabbar.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/6.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRVoiceRoomTabbarDelgate <NSObject>
- (void)inputViewHeightDidChanged:(CGFloat)aChangeHeight
                         duration:(CGFloat)aDuration
                             show:(BOOL)isKeyboardShow;

- (void)likeAction;
- (void)giftAction;
- (void)sendAction:(NSString *)aText;
@end

@interface LRVoiceRoomTabbar : UIView
@property (nonatomic, weak) id <LRVoiceRoomTabbarDelgate> delegate;
@end

NS_ASSUME_NONNULL_END
