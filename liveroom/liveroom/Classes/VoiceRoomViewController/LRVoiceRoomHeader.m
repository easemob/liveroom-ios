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
@property (nonatomic, assign) SEL action;
@end

@implementation LRVoiceRoomHeaderItem
+ (LRVoiceRoomHeaderItem *)itemWithImage:(UIImage *)aImg
                                  action:(SEL)aAction
{
    LRVoiceRoomHeaderItem *btn = [LRVoiceRoomHeaderItem buttonWithType:UIButtonTypeCustom];
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn strokeWithColor:LRStrokeWhite];
    btn.action = aAction;
    return btn;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end

@interface LRVoiceRoomHeader()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation LRVoiceRoomHeader

- (instancetype)initWithTitle:(NSString *)aTitle info:(NSString *)aInfo {
    if (self = [super init]) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLabel];
        
        if (aTitle) self.titleLabel.text = aTitle;
        if (aInfo) self.infoLabel.text = aTitle;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void) setupSubViews {
    
}

#pragma mark - public


#pragma mark - private
- (void)removeItems {
    for (LRVoiceRoomHeaderItem *item in _actionList) {
        [item removeFromSuperview];
    }
}

- (void)addItems {
    for (int i = (int)_actionList.count - 1; i >= 0; i--) {
        LRVoiceRoomHeaderItem *item = _actionList[i];
        [self addSubview:item];
        int count = (int)self.actionList.count - 1 - i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.width.height.equalTo(@kItemSize);
            CGFloat left = -(kItemPadding + kItemSize) * count;
            make.right.equalTo(self).offset(left);
        }];
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:13];
        _infoLabel.textColor = [UIColor whiteColor];
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
    
    [self setupSubViews];
}

@end
