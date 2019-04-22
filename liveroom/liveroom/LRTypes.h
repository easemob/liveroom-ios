//
//  LRTypes.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/22.
//  Copyright © 2019 Easemob. All rights reserved.
//

#ifndef LRTypes_h
#define LRTypes_h


// 会议模式
typedef enum : NSUInteger {
    LRRoomType_Communication = 1,   // 互动模式
    LRRoomType_Host,                // 主持模式
    LRRoomType_Monopoly             // 抢麦模式
} LRRoomType;

// 角色
typedef enum : NSUInteger {
    LRUserType_Admin,
    LRUserType_Speaker,
    LRUserType_Audiance,
} LRUserRoleType;

#endif /* LRTypes_h */
