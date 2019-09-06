//
//  LRVoiceChatRoomListCell.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRVoiceChatRoomListCell.h"
#import "LRRoomModel.h"
#import "Headers.h"

@implementation LRVoiceChatRoomListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 1;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)_setupSubviews
{
    self.backgroundColor = LRColor_HeightBlackColor;
    self.chatRoomNameLabel = [[UILabel alloc] init];
    self.chatRoomNameLabel.textColor = [UIColor whiteColor];
    self.chatRoomNameLabel.font = [UIFont systemFontOfSize:16];
    self.chatRoomNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.chatRoomNameLabel];
    [self.chatRoomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.textColor = LRColor_LowBlackColor;
    self.userNameLabel.font = [UIFont systemFontOfSize:13];
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.roomTpyeLabel = [[UILabel alloc] init];
    self.roomTpyeLabel.textColor = [UIColor whiteColor];
    self.roomTpyeLabel.font = [UIFont systemFontOfSize:13];
    self.roomTpyeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.roomTpyeLabel];
    [self.roomTpyeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
    }];
<<<<<<< HEAD
=======
    
>>>>>>> easemob/dev
}

- (void)setModel:(LRRoomModel *)model
{
    _model = model;
    _chatRoomNameLabel.text = _model.roomname;
    _userNameLabel.text = _model.roomId;
    NSString *roomType;
    if (_model.roomType == LRRoomType_Communication) {
        roomType = @"自由麦模式";
    } else if (_model.roomType == LRRoomType_Host) {
        roomType = @"主持模式";
    } else if (_model.roomType == LRRoomType_Monopoly) {
        roomType = @"抢麦模式";
    } else if (_model.roomType == LRRoomType_Pentakill) {
        roomType = @"狼人杀模式";
    }
    _roomTpyeLabel.text = roomType;
}

@end
