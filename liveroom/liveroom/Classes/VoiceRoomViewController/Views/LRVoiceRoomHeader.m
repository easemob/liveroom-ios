//
//  LRVoiceRoomHeader.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVoiceRoomHeader.h"
#import "Headers.h"


#define kItemPadding 10
#define kItemSize 35

@interface LRVoiceRoomHeaderItem ()
@property (nonatomic) SEL action;
@property (nonatomic, weak) id target;
@end

@implementation LRVoiceRoomHeaderItem
+ (LRVoiceRoomHeaderItem *)itemWithImage:(UIImage *)aImg
                                  target:(id)aTarget
                                  action:(SEL)aAction
{
    LRVoiceRoomHeaderItem *btn = [LRVoiceRoomHeaderItem buttonWithType:UIButtonTypeCustom];
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn strokeWithColor:LRStrokeLowBlack];
    if (aAction) btn.action = aAction;
    if (aTarget) btn.target = aTarget;
    return btn;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end

@interface LRVoiceRoomHeader()
{
    CGFloat _leftItemX;
    int _musictimer;
    NSString *_musicName;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation LRVoiceRoomHeader

- (instancetype)initWithTitle:(NSString *)aTitle info:(NSString *)aInfo {
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLabel];
        
        if (aTitle) self.titleLabel.text = aTitle;
        if (aInfo) self.infoLabel.text = aInfo;
    }
    return self;
}

#pragma mark - subViews

- (void)setupTitleLabelSize {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self).offset(-(self->_leftItemX));
        make.height.equalTo(@(kItemSize - 15));
    }];
    
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.height.equalTo(@(15));
    }];
}

#pragma mark - public

#pragma mark - private
- (void)removeItems {
    for (LRVoiceRoomHeaderItem *item in _actionList) {
        [item removeFromSuperview];
    }
}

- (void)addItems {
    __block CGFloat left = 0;
    for (int i = (int)_actionList.count - 1; i >= 0; i--) {
        LRVoiceRoomHeaderItem *item = _actionList[i];
        [item addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        int count = (int)self.actionList.count - 1 - i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.width.height.equalTo(@kItemSize);
            left = (kItemPadding + kItemSize) * count;
            make.right.equalTo(self).offset(-left);
        }];
    }
    _leftItemX = left + kItemPadding + kItemSize;
}

- (void)itemDidClicked:(LRVoiceRoomHeaderItem *)aItem {
    if (aItem.target && aItem.action) {
        SEL selector = aItem.action;
        IMP imp = [aItem.target methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(aItem.target, selector);
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:13];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.numberOfLines = 1;
    }
    return _infoLabel;
}

#pragma mark - setter
- (void)setActionList:(NSArray *)actionList {
    if (_actionList && _actionList.count > 0) {
        [self removeItems];
    }
    _actionList = actionList;
    
    if (_actionList && _actionList.count > 0) {
        [self addItems];
    }
    
    [self setupTitleLabelSize];
}

@end

