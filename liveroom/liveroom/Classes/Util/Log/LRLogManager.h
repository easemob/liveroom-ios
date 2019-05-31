//
//  LRLogManager.h
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/3/26.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

NS_ASSUME_NONNULL_BEGIN

@interface LRLogManager : NSObject
+ (LRLogManager *)shareManager;
- (void)start;                              // 配置日志信息
@end

NS_ASSUME_NONNULL_END
