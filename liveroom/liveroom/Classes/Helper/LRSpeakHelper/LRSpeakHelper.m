//
//  LRSpeakHelper.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakHelper.h"

@interface LRSpeakHelper () <EMConferenceManagerDelegate>

@end

@implementation LRSpeakHelper
+ (LRSpeakHelper *)sharedInstance {
    static dispatch_once_t onceToken;
    static LRSpeakHelper *helper_;
    dispatch_once(&onceToken, ^{
        helper_ = [[LRSpeakHelper alloc] init];
    });
    return helper_;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
