//
//  TCSettingTableViewCell.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/4.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSettingTableViewCell.h"
@interface LRSettingTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@end
@implementation LRSettingTableViewCell

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
    self.backgroundColor = LRColor_HeightBlackColor;
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLabel];

    self.detailsLabel = [[UILabel alloc] init];
    [self.detailsLabel setTextColor:LRColor_LowBlackColor];
    self.detailsLabel.font = [UIFont systemFontOfSize:10];
    self.detailsLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.detailsLabel];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-36);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
    [self setNeedsLayout];
}

- (void)setDetails:(NSString *)details
{
    _details = details;
    _detailsLabel.text = _details;
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
    if (_details != nil) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(16);
            make.width.equalTo(@240);
            make.height.equalTo(@25);
        }];
        
        [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentView).offset(16);
            make.width.equalTo(@240);
            make.height.equalTo(@19);
        }];
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@240);
            make.height.equalTo(@30);
        }];
    }
}

@end
