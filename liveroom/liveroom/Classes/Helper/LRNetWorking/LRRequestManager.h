//
//  LRRequestManager.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/11.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRRequestManager : NSObject

+ (LRRequestManager *)sharedInstance;

// 请求
- (void)requestWithMethod:(NSString *)method urlString:(NSString *)url
                     parameters:(NSDictionary *__nullable)parameters
                           token:(NSString *__nullable)token
                      completion:(void (^ _Nullable)(NSDictionary *result,NSError *error))aCompletionBlock;

@end

NS_ASSUME_NONNULL_END
