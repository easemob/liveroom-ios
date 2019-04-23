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

@interface LRSpeakerCellModel : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *streamId;
@property (nonatomic) LRRoomType type;
@property (nonatomic) BOOL isOwner;
@property (nonatomic) BOOL isAdmin;
@property (nonatomic) BOOL isMyself;

@property (nonatomic) BOOL speakOn;
@property (nonatomic) BOOL talkOn;
@property (nonatomic) BOOL argumentOn;
@property (nonatomic) BOOL unArgumentOn;

@end

NS_ASSUME_NONNULL_END
