//
//  LRChatRoomListModel.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRChatRoomListModel : NSObject

@property (nonatomic, strong) NSString *chatRoomName;
@property (nonatomic, strong) NSString *userName;

+ (instancetype)initWithChatRoomDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
