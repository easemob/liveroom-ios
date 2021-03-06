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
@property (nonatomic) int conferencePassword;
@property (nonatomic, assign) LRRoomType roomType;

@property (nonatomic) LRTerminator clockStatus;//狼人杀模式当前时钟状态
@property (nonatomic,strong) NSString *identity;//狼人杀模式本地身份

+ (instancetype)roomWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
