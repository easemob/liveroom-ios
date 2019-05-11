//
//  LRRoomModel.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRRoomModel : NSObject

@property (nonatomic, copy) NSString *roomname;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *conferenceId;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic) int maxCount;
@property (nonatomic) BOOL allowAudienceOnSpeaker;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) LRRoomType roomType;

+ (instancetype)roomWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
