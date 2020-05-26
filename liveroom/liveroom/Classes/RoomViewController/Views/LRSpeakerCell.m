//
//  LRSpeakerCell.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakerCell.h"
#import "Headers.h"
#import "UIResponder+LRRouter.h"
#import "LRSpeakerCommunicationCell.h"
#import "LRSpeakerHostCell.h"
#import "LRSpeakerMonopolyCell.h"



NSString *DISCONNECT_EVENT_NAME          = @"disconnectEventName";

@interface LRSpeakerCell ()

@end

@implementation LRSpeakerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = LRColor_HeightBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(streamIdsNoti:)
                                                     name:LR_Stream_Did_Speaking_Notification
                                                   object:nil];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.contentView addSubview:self.lightView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.crownImage];
    [self.contentView addSubview:self.volumeView];
    [self.contentView addSubview:self.lineView];
    
    
    [self.lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.width.height.equalTo(@8);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.lessThanOrEqualTo(self.volumeView.mas_left).offset(-32);
        make.bottom.equalTo(self.lineView.mas_top).offset(-5).priorityLow();
    }];
    
    [self.crownImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.height.width.equalTo(@12);
    }];
    
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@10);
        make.height.equalTo(@18);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@2);
    }];
    
    [self layoutIfNeeded];
    
}

- (void)streamIdsNoti:(NSNotification *)notification
{
    NSArray *array = notification.object;
    if (array.count != 0) {
        if ([array containsObject:self.model.streamId]) {
            [self.volumeView setProgress:1];
        }
    } else {
        [self.volumeView setProgress:0];
    }
}
// 管理员皇冠👑 & cell 边框
- (void)updateSubViewUI {
    self.nameLabel.text = _model.username;
    self.lightView.backgroundColor = _model.speakOn ? [UIColor greenColor] : LRColor_MiddleBlackColor;
    if (_model.isAdmin) {
        self.crownImage.hidden = NO;
    }else {
        self.crownImage.hidden = YES;
    }
    
    if (self.model.isMyself) {
        [self.contentView cellWithContentView:self.contentView StrokeWithColor:LRColor_LowBlackColor borderWidth:2];
    }
}

#pragma mark - actions
- (void)disconnectAction:(UIButton *)aBtn {
    [self btnSelectedWithEventName:DISCONNECT_EVENT_NAME];
}

- (void)btnSelectedWithEventName:(NSString *)aEventName {
    NSLog(@"\n--------->eventname:   %@    %@",aEventName,self.model);
    [self routerEventWithName:aEventName userInfo:@{@"key" : self.model}];
}

#pragma mark - getter
- (UIView *)lightView {
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _lightView.layer.masksToBounds = YES;
        _lightView.layer.cornerRadius = 4;
        _lightView.backgroundColor = [UIColor greenColor];
    }
    return _lightView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    return _nameLabel;
}

- (UIImageView *)crownImage {
    if (!_crownImage) {
        _crownImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _crownImage.image = [UIImage imageNamed:@"king"];
    }
    return _crownImage;
}

- (LRVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[LRVolumeView alloc] initWithFrame:CGRectZero];
        _volumeView.progress = 0.5;
    }
    return _volumeView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
