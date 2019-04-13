//
//  LRSpeakerViewController.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LRSpeakerCellModel;
@interface LRSpeakerViewController : UIViewController
@property (nonatomic, strong) NSDictionary *roomInfo;
@end

@interface LRSpeakerCell : UITableViewCell
@property (nonatomic, strong) LRSpeakerCellModel *model;
@end

@interface LRSpeakerCellModel : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic) BOOL isAdmin;
@property (nonatomic) BOOL isMyself;
@property (nonatomic) BOOL isMute;
@end

NS_ASSUME_NONNULL_END
