//
//  UIImage+LRImageColor.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/11.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "UIImage+LRImageColor.h"

@implementation UIImage (LRImageColor)

+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image {
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
