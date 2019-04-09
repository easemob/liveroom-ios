//
//  LRChatroomMembersCell.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRChatroomMembersCellDelegate;
@class LRChatroomMembersModel;
@interface LRChatroomMembersCell : UITableViewCell

@property (nonatomic, strong) UILabel *memberNameLabel;
@property (nonatomic, strong) UIImageView *ownerIconImageView;
@property (nonatomic, strong) UIButton *exitMemberButton;
@property (nonatomic, strong) LRChatroomMembersModel *model;

@property (nonatomic, weak) id <LRChatroomMembersCellDelegate> delegate;

@end

@protocol LRChatroomMembersCellDelegate <NSObject>
- (void)chatroomMembersExit:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
