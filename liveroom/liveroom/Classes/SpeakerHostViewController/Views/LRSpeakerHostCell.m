//
//  LRSpeakerHostCell.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/20.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerHostCell.h"

NSString *TALK_EVENT_NAME                = @"talkEventName";
@interface LRSpeakerHostCell ()
// 指定说话按钮
@property (nonatomic, strong) UIButton *talkBtn;
// 断开按钮
@property (nonatomic, strong) UIButton *disconnectBtn;
@end

@implementation LRSpeakerHostCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    [super _setupSubViews];
    [self.contentView addSubview:self.talkBtn];
    [self.contentView addSubview:self.disconnectBtn];
}

- (void)updateSubViewUI {
    [super updateSubViewUI];
    
    BOOL talkBtnNeedShow = self.model.type == LRRoomType_Host && self.model.isOwner;
    
    if (talkBtnNeedShow) {
        self.talkBtn.hidden = NO;
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
            make.width.equalTo(@(kBtnWidth));
            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
        
        if (self.model.talkOn) {
            [self.talkBtn strokeWithColor:LRStrokePureBlack];
        }else {
            [self.talkBtn strokeWithColor:LRStrokeGreen];
        }
        
    }else {
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.talkBtn.hidden = YES;
    }
    
    BOOL disconnectBtnNeedShow = (!self.model.isMyself && self.model.isOwner) || (self.model.isMyself && !self.model.isOwner);
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
            if (talkBtnNeedShow) {
                make.left.equalTo(self.talkBtn.mas_right).offset(10);
            } else {
                make.left.equalTo(self.nameLabel.mas_left);
            }
            make.width.equalTo(@(kBtnWidth));
            make.bottom.equalTo(self.lineView.mas_top).offset(-6);
        }];
    }else {
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        self.disconnectBtn.hidden = YES;
    }
}

#pragma mark - actions
- (void)talkerAction:(UIButton *)aBtn {
    if (self.model.talkOn == NO) {
        [self btnSelectedWithEventName:TALK_EVENT_NAME];
    }
}

- (UIButton *)talkBtn {
    if (!_talkBtn) {
        _talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_talkBtn strokeWithColor:LRStrokePureBlack];
        [_talkBtn setTitle:@"发言" forState:UIControlStateNormal];
        [_talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _talkBtn.backgroundColor = LRColor_PureBlackColor;
        [_talkBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _talkBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_talkBtn addTarget:self action:@selector(talkerAction:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _talkBtn;
}

- (UIButton *)disconnectBtn {
    if (!_disconnectBtn) {
        _disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disconnectBtn strokeWithColor:LRStrokeRed];
        [_disconnectBtn setTitle:@"下麦" forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _disconnectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _disconnectBtn.backgroundColor = LRColor_PureBlackColor;
        [_disconnectBtn addTarget:self action:@selector(disconnectAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _disconnectBtn;
}

@end
