//
//  UIView+LRCategory.h
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LRStrokeRed,
    LRStrokeBlue,
    LRStrokeBlack,
    LRStrokeWhite
} LRStrokeColor;

@interface UIView (Stroke)
- (void)strokeWithColor:(LRStrokeColor)aColor;
@end

typedef enum : NSUInteger {
    LRTextFieldInputType
} LRTextFieldType;

@interface UITextField (Type)
- (void)setupTextFieldType:(LRTextFieldType)aType;
@end

NS_ASSUME_NONNULL_END
