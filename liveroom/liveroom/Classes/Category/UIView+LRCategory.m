//
//  UIView+LRCategory.m
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "UIView+LRCategory.h"
#import "Headers.h"


@implementation UIView (Stroke)
- (void)strokeWithColor:(LRStrokeColor)aColor {
    UIColor *color = [UIColor whiteColor];
    switch (aColor) {
        case LRStrokeRed:
        {
            color = [UIColor redColor];
        }
            break;
        case LRStrokeBlue:
        {
            color = [UIColor blueColor];
        }
            break;
        case LRStrokeWhite:
        {
            color = [UIColor whiteColor];
        }
            break;
        case LRStrokeLowBlack:
        {
            color = LRColor_LowBlackColor;
        }
            break;
        case LRStrokeGreen:
        {
            color = LRColor_LessGreenColor;
        }
            break;
        default:
            break;
    }
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 2.5;
}

- (void)cellWithContentView:(UIView *)contentView StrokeWithColor:(UIColor *)aColor borderWidth:(CGFloat)width
{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = aColor;
    [contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@(width));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = aColor;
    [contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-width);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@(width));
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = aColor;
    [contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(width);
        make.left.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-width);
        make.width.equalTo(@(width));
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = aColor;
    [contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(width);
        make.bottom.equalTo(contentView).offset(-width);
        make.right.equalTo(contentView);
        make.width.equalTo(@(width));
    }];
}

- (void)disableStroke {
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
}
@end

@implementation UITextField (Type)
- (void)setupTextField{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.backgroundColor = LRColor_HeightBlackColor;
    self.textColor = [UIColor whiteColor];
    [self setValue:LRColor_LowBlackColor forKeyPath:@"_placeholderLabel.textColor"];
}

@end
