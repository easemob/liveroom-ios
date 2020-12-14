//
//  LRRoomModel.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRoomModel.h"

@implementation LRRoomModel

+ (instancetype)roomWithDict:(NSDictionary *)retDict
{
    LRRoomModel *model = [[LRRoomModel alloc] init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in retDict.allKeys) {
        if (![retDict[key] isKindOfClass:[NSNull class]]) {
            dict[key] = retDict[key];
        }
    }
    
    model.roomname = dict[@"roomName"];
    model.roomId = dict[@"roomId"];
    model.conferenceId = dict[@"rtcConfrId"];
    model.owner = dict[@"ownerName"];
    model.maxCount = [dict[@"rtcConfrAudienceLimit"] intValue];
    model.createTime =  dict[@"rtcConfrCreateTime"];
    model.allowAudienceOnSpeaker = [dict[@"allowAudienceTalk"] boolValue];
    model.conferencePassword = [dict[@"rtcConfrPassword"] intValue];
    NSString *roomType = dict[@"roomtype"];
    if (![roomType isEqual:[NSNull null]] && roomType != nil) {
        if ([roomType isEqualToString:@"communication"]) {
            model.roomType = LRRoomType_Communication;
        } else if ([roomType isEqualToString:@"host"]) {
            model.roomType = LRRoomType_Host;
        } else if ([roomType isEqualToString:@"monopoly"]) {
            model.roomType = LRRoomType_Monopoly;
        } else {
            model.roomType = LRRoomType_Pentakill;
        }
    } else {
        NSLog(@"更新--------");
    }
    return model;
}

@end
