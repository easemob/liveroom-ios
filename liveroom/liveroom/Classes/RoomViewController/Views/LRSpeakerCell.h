//
//  LRSpeakerCell.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"
#import "LRVolumeView.h"
#import "LRSpeakerCellModel.h"


NS_ASSUME_NONNULL_BEGIN
#define kBtnWidth 80
@class LRSpeakerCellModel, LRRoomModel;
@interface LRSpeakerCell : UITableViewCell
@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *crownImage;
@property (nonatomic, strong) LRVolumeView *volumeView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) LRSpeakerCellModel *model;
- (void)updateSubViewUI;

//+ (LRSpeakerCell *)speakerCellWithType:(LRRoomType)aType
//                             tableView:(UITableView *)aTableView
//                             cellModel:(id)aModel;
- (void)disconnectAction:(UIButton *)aBtn;

- (void)btnSelectedWithEventName:(NSString *)aEventName;

- (void)_setupSubViews;

@end

NS_ASSUME_NONNULL_END
