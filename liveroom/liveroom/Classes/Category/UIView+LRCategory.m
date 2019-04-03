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
    self.layer.borderWidth = 3;
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
        case LRStrokeBlack:
        {
            color = [UIColor blackColor];
        }
            break;
        case LRStrokeWhite:
        {
            color = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
    self.layer.borderColor = [color colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 2.5;
}
@end

@implementation UITextField (Type)
- (void)setupTextFieldType:(LRTextFieldType)aType
{
    switch (aType) {
        case LRTextFieldInputType:
        {
            self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
            self.leftViewMode = UITextFieldViewModeAlways;
            self.backgroundColor = LRColor_InputTextColor;
            [self setValue:RGBACOLOR(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
        }
            break;
            
        default:
            break;
    }
}
@end
