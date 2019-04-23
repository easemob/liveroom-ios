//
//  LRSpeakerCell.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"



NS_ASSUME_NONNULL_BEGIN
@class LRSpeakerCellModel, LRRoomModel;
@interface LRSpeakerCell : UITableViewCell
@property (nonatomic, strong) LRSpeakerCellModel *model;
- (void)updateSubViewUI;

+ (LRSpeakerCell *)speakerCellWithType:(LRRoomType)aType
                             tableView:(UITableView *)aTableView
                             cellModel:(id)aModel;

@end


@interface LRSpeakerHostCell : LRSpeakerCell

@end

@interface LRSpeakerCommunicationCell : LRSpeakerCell

@end

@interface LRSpeakerMonopolyCell : LRSpeakerCell

@end
NS_ASSUME_NONNULL_END
