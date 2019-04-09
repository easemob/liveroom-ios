//
//  LRMusicPlayerHelper.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRMusicItem : NSObject
+ (LRMusicItem *)itemWithName:(NSString *)aName totalTime:(int)aTotalTime;
@property (nonatomic) int totalTime;
@property (nonatomic, strong) NSString *itemName;
@end

@protocol LRMusicPlayerHelperDelegate <NSObject>
- (void)musicDidChanged:(LRMusicItem *)item;
- (void)currentTimeChanged:(int)currentTime totalTime:(int)aTotalTime;
@end

@interface LRMusicPlayerHelper : NSObject
@property (nonatomic, readonly) BOOL isPlay;
@property (nonatomic, readonly) int currentTime;
@property (nonatomic, strong, readonly) LRMusicItem *currentItem;
@property (nonatomic, strong) NSArray <LRMusicItem *>* playList;
+ (LRMusicPlayerHelper *)sharedInstance;
- (void)destroy;

- (void)addDelegate:(id<LRMusicPlayerHelperDelegate>)aDelegate delegateQueue:(_Nullable dispatch_queue_t)aQueue;

- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
