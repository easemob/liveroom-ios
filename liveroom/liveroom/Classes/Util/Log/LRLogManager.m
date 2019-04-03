//
//  LRLogManager.m
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/3/26.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRLogManager.h"

@interface LRLogManager ()
@property(nonatomic, strong) DDFileLogger *fileLogger;
@end

@implementation LRLogManager
{
    id _logFormatter;
}

+ (LRLogManager *)shareManager
{
    static LRLogManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LRLogManager alloc] init];
        
    });
    return manager;
}

- (void)start
{
#if DEBUG
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger withLevel:DDLogLevelVerbose];
#endif
    [DDLog addLogger:self.fileLogger withLevel:DDLogLevelVerbose];
}

- (DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Log"];
        DDLogFileManagerDefault *fD = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:path];
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fD];
        _fileLogger.rollingFrequency = 60 * 60 * 24;
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    }
    
    return _fileLogger;
}

@end
