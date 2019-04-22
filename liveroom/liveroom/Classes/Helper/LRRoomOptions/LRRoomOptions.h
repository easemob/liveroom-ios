//
//  LRRoomOptions.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/15.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *lrOptions_Version = @"Appkey";
static NSString *lrOptions_SpeakerNumber = @"SpeakerNumber";
static NSString *lrOptions_AllowAudienceApplyInteract = @"AllowAudienceApplyInteract";
static NSString *lrOptions_AudioQuality = @"AudioQuality";
static NSString *lrOptions_AllowApplyAsSpeaker = @"AllowApplyAsSpeaker";
static NSString *lrOptions_AutomaticallyTurnOnMusic = @"AutomaticallyTurnOnMusic";

@interface LRRoomOptions : NSObject <NSCoding>

@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) int speakerNumber;
@property (nonatomic, assign) BOOL isAllowAudienceApplyInteract;
@property (nonatomic, strong) NSString *audioQuality;
@property (nonatomic, assign) BOOL isAllowApplyAsSpeaker;
@property (nonatomic, assign) BOOL isAutomaticallyTurnOnMusic;

+ (LRRoomOptions *)sharedOptions;

- (void)archive;

@end

NS_ASSUME_NONNULL_END
