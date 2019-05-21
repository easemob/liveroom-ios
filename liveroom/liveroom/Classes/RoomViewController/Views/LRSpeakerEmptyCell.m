//
//  LRSpeakerEmptyCell.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/23.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakerEmptyCell.h"

@interface LRSpeakerEmptyCell ()
@property (nonatomic, strong) UIView *emptyLightView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LRSpeakerEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = LRColor_HeightBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.contentView addSubview:self.emptyLightView];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.emptyLightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.infoLabel);
        make.right.equalTo(self.infoLabel.mas_left).offset(-5);
        make.width.height.equalTo(@8);
    }];
    
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.lineView.mas_top).offset(-5);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@2);
    }];
}


#pragma mark - getter
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = LRColor_MiddleBlackColor;
        _infoLabel.font = [UIFont boldSystemFontOfSize:19];
        _infoLabel.text = @"disconnect";
    }
    return _infoLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

- (UIView *)emptyLightView {
    if (!_emptyLightView) {
        _emptyLightView = [[UIView alloc] init];
        _emptyLightView.layer.masksToBounds = YES;
        _emptyLightView.layer.cornerRadius = 4;
        _emptyLightView.backgroundColor = LRColor_MiddleBlackColor;
    }
    return _emptyLightView;
}

@end
