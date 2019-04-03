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

- (void)_setupSubviews
{
    self.chatRoomNameLabel = [[UILabel alloc] init];
    self.chatRoomNameLabel.font = [UIFont systemFontOfSize:16];
    self.chatRoomNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.chatRoomNameLabel];
    [_chatRoomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
}

- (void)setModel:(LRChatRoomListModel *)model
{
    _model = model;
    self.chatRoomNameLabel.text = model.chatRoomName;
}

@end
