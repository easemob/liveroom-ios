//
//  LRVoiceChatRoomListCell.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LRRoomModel;
@interface LRVoiceChatRoomListCell : UITableViewCell

@property (nonatomic, strong) UILabel *chatRoomNameLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *roomTpyeLabel;
@property (nonatomic, strong) UIImageView *lockImage;
@property (nonatomic, strong) LRRoomModel *model;

@end

NS_ASSUME_NONNULL_END
