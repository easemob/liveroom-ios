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
            color = [UIColor greenColor];
        }
            break;
        default:
            break;
    }
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 2.5;
}

- (void)cellStrokeWithColor:(UIColor *)aColor borderWidth:(CGFloat)width
{
    self.layer.borderColor = aColor.CGColor;
    self.layer.borderWidth = width;
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
