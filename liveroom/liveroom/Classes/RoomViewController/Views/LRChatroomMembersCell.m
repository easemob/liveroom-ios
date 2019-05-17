//
//  LRChatroomMembersCell.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRChatroomMembersCell.h"
#import "LRChatroomMembersModel.h"

@interface LRChatroomMembersCell ()

@property (nonatomic, assign) BOOL isOwner;

@end

@implementation LRChatroomMembersCell

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
    [self cellWithContentView:self StrokeWithColor:LRColor_LessBlackColor borderWidth:2];
    
    self.memberNameLabel = [[UILabel alloc] init];
    self.memberNameLabel.font = [UIFont systemFontOfSize:17.0];
    [self.memberNameLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.memberNameLabel];
    [self.memberNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(@16);
        make.height.equalTo(@31);
    }];
    
    self.ownerIconImageView = [[UIImageView alloc] init];
    self.ownerIconImageView.image = [UIImage imageNamed:@"king"];
    [self.contentView addSubview:self.ownerIconImageView];
    [self.ownerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.memberNameLabel.mas_right).offset(5);
        make.width.equalTo(@13);
        make.height.equalTo(@12);
    }];
    
    self.exitMemberButton = [[UIButton alloc] init];
    [self.exitMemberButton setTitle:@"踢出 exit" forState:UIControlStateNormal];
    self.exitMemberButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.exitMemberButton.layer.borderColor = LRColor_LessBlackColor.CGColor;
    self.exitMemberButton.layer.borderWidth = 1;
    [self.exitMemberButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.exitMemberButton addTarget:self action:@selector(exitMemberButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.exitMemberButton];
    [self.exitMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
}

- (void)exitMemberButtonAction
{
    if ([self.delegate respondsToSelector:@selector(chatroomMembersExit:)]) {
        [self.delegate chatroomMembersExit:_model];
    }
}

- (void)setModel:(LRChatroomMembersModel *)model
{
    _model = model;
    _memberNameLabel.text = _model.memberName;
    _isOwner = _model.isOwner;
    
    if (_isOwner) {
        self.exitMemberButton.hidden = YES;
        self.ownerIconImageView.hidden = NO;
    } else {
        if ([[EMClient sharedClient].currentUsername isEqualToString:_model.ownerName]) {
            self.exitMemberButton.hidden = NO;
            self.ownerIconImageView.hidden = YES;
        } else {
            self.exitMemberButton.hidden = YES;
            self.ownerIconImageView.hidden = YES;
        }
    }
}

@end
