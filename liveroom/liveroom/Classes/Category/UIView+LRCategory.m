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
    self.layer.borderColor = LRColor_LowBlackColor.CGColor;
    self.layer.borderWidth = 2.5;
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
    self.backgroundColor = LRColor_InputTextColor;
    [self setValue:RGBACOLOR(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
}

@end
