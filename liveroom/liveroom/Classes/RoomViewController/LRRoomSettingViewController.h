//
//  LRRoomSettingViewController.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/28.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRRoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LRRoomSettingViewController : UIViewController
@property (nonatomic, strong) NSString *rommPassword;
@property (nonatomic, assign) int speakerLimited;
@property (nonatomic, strong) LRRoomModel *model;
@end

NS_ASSUME_NONNULL_END
