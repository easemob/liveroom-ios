//
//  NSString+Category.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/5/9.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
- (NSDictionary *)toDict {
    if (self.length == 0) return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

@end
