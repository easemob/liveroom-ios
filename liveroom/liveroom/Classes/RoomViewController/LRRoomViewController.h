//
//  LRRoomViewController.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"
NS_ASSUME_NONNULL_BEGIN

@class LRRoomModel;
@interface LRRoomViewController : UIViewController

@property (nonatomic) BOOL isOwner;

- (instancetype)initWithUserType:(LRUserRoleType)aType
                       roomModel:(LRRoomModel *)aRoomModel
                        password:(NSString *)aPassword;

@end

NS_ASSUME_NONNULL_END
