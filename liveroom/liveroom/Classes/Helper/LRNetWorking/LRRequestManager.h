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

// get请求
- (void)getNetworkRequestWithUrl:(NSString *)url
                           token:(NSString *)token
                      completion:(void (^)(NSString *result,NSError *error))aCompletionBlock;

// 请求
- (void)postNetworkRequestWithUrl:(NSString *)url
                      requestBody:(NSDictionary *)requestBody
                            token:(NSString *)token
                       completion:(void (^)(NSString *result,NSError *error))aCompletionBlock;

// delete请求
- (void)deleteNetworkRequestWithUrl:(NSString *)url
                              token:(NSString *)token
                         completion:(void (^)(NSString *result,NSError *error))aCompletionBlock;

@end

NS_ASSUME_NONNULL_END
