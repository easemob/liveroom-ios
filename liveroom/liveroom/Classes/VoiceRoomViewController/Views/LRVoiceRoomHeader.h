//
//  LRVoiceRoomHeader.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRVoiceRoomHeaderItem : UIButton
+ (LRVoiceRoomHeaderItem *)itemWithImage:(UIImage *)aImg
                                  target:(id __nullable)aTarget
                                  action:(SEL __nullable)aAction;
@end

@protocol LRVoiceRoomHeaderDelegate <NSObject>
- (void)playerDidBegin;
- (void)playerDidEnd;
@end

@interface LRVoiceRoomHeader : UIView
@property (nonatomic, strong) NSArray *actionList;
- (instancetype)initWithTitle:(NSString *)aTitle info:(NSString *)aInfo;
- (void)setupMusicName:(NSString *)aName timer:(int)aTimer;
@end

@interface LRVoiceRoomHeaderPlayerView : UIView
- (void)editEnable:(BOOL)isEnable;
- (void)setupMusicName:(NSString *)aName timer:(int)aTimer;
@end

NS_ASSUME_NONNULL_END
