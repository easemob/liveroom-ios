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
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0.5);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(0.5);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    
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
    self.ownerIconImageView.image = [UIImage imageNamed:@"crown"];
    [self.contentView addSubview:self.ownerIconImageView];
    [self.ownerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.memberNameLabel.mas_right).offset(5);
        make.width.equalTo(@13);
        make.height.equalTo(@12);
    }];
    
    self.exitMemberButton = [[UIButton alloc] init];
    [self.exitMemberButton setTitle:@"踢出 exit" forState:UIControlStateNormal];
    self.exitMemberButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.exitMemberButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.exitMemberButton.layer.borderWidth = 0.5;
    [self.exitMemberButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.exitMemberButton addTarget:self action:@selector(exitMemberButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.exitMemberButton];
    [self.exitMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
}

- (void)setModel:(LRChatroomMembersModel *)model
{
    _model = model;
    _memberNameLabel.text = _model.memberName;
    _isOwner = _model.isOwner;
    
    if (_isOwner) {
        self.exitMemberButton.hidden = YES;
    } else {
        self.ownerIconImageView.hidden = YES;
    }
}

- (void)exitMemberButtonAction
{
    if ([self.delegate respondsToSelector:@selector(chatroomMembersExit:)]) {
        [self.delegate chatroomMembersExit:self.exitMemberButton];
    }
}

@end
