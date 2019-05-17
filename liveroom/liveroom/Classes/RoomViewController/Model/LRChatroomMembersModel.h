//
//  LRChatroomMembersModel.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRChatroomMembersModel : NSObject

@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, assign) BOOL isOwner;

+ (instancetype)initWithChatroomMembersDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
