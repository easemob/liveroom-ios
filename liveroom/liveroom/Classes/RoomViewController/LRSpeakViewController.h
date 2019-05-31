//
//  LRSpeakViewController.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"

NS_ASSUME_NONNULL_BEGIN

@class LRSpeakerCellModel, LRRoomModel;
@interface LRSpeakViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) LRRoomModel *roomModel;
@property (nonatomic, strong) NSMutableArray *memberList;
@end

NS_ASSUME_NONNULL_END
