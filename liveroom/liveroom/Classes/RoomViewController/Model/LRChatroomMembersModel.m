//
//  LRChatroomMembersModel.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRChatroomMembersModel.h"

@implementation LRChatroomMembersModel

+ (instancetype)initWithChatroomMembersDict:(NSDictionary *)dict
{
    LRChatroomMembersModel *model = [[LRChatroomMembersModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
