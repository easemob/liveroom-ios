//
//  LRMusicPlayerHelper.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRMusicPlayerHelper.h"
#import "LRGCDMulticastDelegate.h"

@implementation LRMusicItem
+ (LRMusicItem *)itemWithName:(NSString *)aName totalTime:(int)aTotalTime {
    LRMusicItem *item = [[LRMusicItem alloc] init];
    item.totalTime = aTotalTime;
    item.itemName = aName;
    return item;
}
@end

@interface LRMusicPlayerHelper () {
    LRGCDMulticastDelegate<LRMusicPlayerHelperDelegate> *_delegates;
    int _index;
}
@end

@implementation LRMusicPlayerHelper
static LRMusicPlayerHelper *playerHelper;
static dispatch_once_t onceToken;

#pragma mark - public
+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

- (void)addDelegate:(id<LRMusicPlayerHelperDelegate>)aDelegate delegateQueue:(dispatch_queue_t)aQueue {
    if (aQueue == nil) {
        aQueue = dispatch_get_main_queue();
    }
    [_delegates addDelegate:aDelegate delegateQueue:aQueue];
}

- (void)destroy {
    [_delegates removeAllDelegates];
    _delegates = nil;
    playerHelper = nil;
    onceToken = 0;
}

- (void)play {
    
    if (_isPlay) {
        return;
    }
    
    if (self.playList.count == 0) {
        return;
    }
    
    if (!_currentItem) {
        _index += 1;
        _currentItem = self.playList[_index];
    }
    [self playItem:_currentItem];
}

- (void)pause {
    _isPlay = NO;
}

#pragma mark - private
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        playerHelper = [super allocWithZone:zone];
    });
    
    return playerHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        _index = -1;
        _delegates = [[LRGCDMulticastDelegate<LRMusicPlayerHelperDelegate> alloc] init];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return playerHelper;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return playerHelper;
}

- (void)playItem:(LRMusicItem *)item {
    
}

@end
