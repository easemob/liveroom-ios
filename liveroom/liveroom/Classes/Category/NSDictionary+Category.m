//
//  NSDictionary+Category.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/5/9.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)
- (NSString *)toJsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return dataStr;
}
@end
