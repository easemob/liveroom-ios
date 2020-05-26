//
//  LRSpeakViewController.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"
#import "LRSpeakerEmptyCell.h"
#import "LRSpeakerTypeView.h"
#import "LRRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LRSpeakerCellModel;
@interface LRSpeakViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) LRRoomModel *roomModel;
@property (nonatomic, strong) NSMutableArray *memberList;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) LRSpeakerTypeView *headerView;
- (void)setupSubViews;
@end

NS_ASSUME_NONNULL_END
