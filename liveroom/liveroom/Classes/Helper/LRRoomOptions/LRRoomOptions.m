//
//  LRRoomOptions.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/15.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRoomOptions.h"

static LRRoomOptions *options = nil;
@implementation LRRoomOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speakerNumber = 6;
        self.isAllowAudienceApplyInteract = YES;
        self.audioQuality = @"50";
        self.isAllowApplyAsSpeaker = NO;
        self.isAutomaticallyTurnOnMusic = NO;
    }
    return self;
}

+ (LRRoomOptions *)sharedOptions
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = [LRRoomOptions getOptionsFromLocal];
    });
    return options;
}

+ (LRRoomOptions *)getOptionsFromLocal
{
    LRRoomOptions *model = nil;
    NSString *fileName = @"lrroom_options.data";
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    model = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (!model) {
        model = [[LRRoomOptions alloc] init];
        [model archive];
    }
    return model;
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.speakerNumber = [aDecoder decodeIntForKey:lrOptions_SpeakerNumber];
        self.isAllowAudienceApplyInteract = [aDecoder decodeBoolForKey:lrOptions_AllowAudienceApplyInteract];
        self.audioQuality = [aDecoder decodeObjectForKey:lrOptions_AudioQuality];
        self.isAllowApplyAsSpeaker = [aDecoder decodeBoolForKey:lrOptions_AllowApplyAsSpeaker];
        self.isAutomaticallyTurnOnMusic = [aDecoder decodeBoolForKey:lrOptions_AutomaticallyTurnOnMusic];
    }
    return self;
}

- (NSString *)version {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@(%@)",version, build];
}


// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.speakerNumber forKey:lrOptions_SpeakerNumber];
    [aCoder encodeBool:self.isAllowAudienceApplyInteract forKey:lrOptions_AllowAudienceApplyInteract];
    [aCoder encodeObject:self.audioQuality forKey:lrOptions_AudioQuality];
    [aCoder encodeBool:self.isAllowApplyAsSpeaker forKey:lrOptions_AllowApplyAsSpeaker];
    [aCoder encodeBool:self.isAutomaticallyTurnOnMusic forKey:lrOptions_AutomaticallyTurnOnMusic];
}

- (void)archive
{
    NSString *fileName = @"lrroom_options.data";
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:self toFile:file];
}

@end
