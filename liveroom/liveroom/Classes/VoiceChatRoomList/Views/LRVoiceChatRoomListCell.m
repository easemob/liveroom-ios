//
//  LRVoiceChatRoomListCell.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRVoiceChatRoomListCell.h"
#import "LRChatRoomListModel.h"
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
    
}

- (void)setModel:(LRChatRoomListModel *)model
{
    _model = model;
    _chatRoomNameLabel.text = _model.chatRoomName;
    _userNameLabel.text = _model.userName;
}

@end
