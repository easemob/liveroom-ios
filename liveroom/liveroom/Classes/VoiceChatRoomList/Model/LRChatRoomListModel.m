//
//  LRChatRoomListModel.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRChatRoomListModel.h"

@implementation LRChatRoomListModel

+ (instancetype)initWithChatRoomDict:(NSDictionary *)dict
{
    LRChatRoomListModel *model = [[LRChatRoomListModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
