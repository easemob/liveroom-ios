//
//  LRRequestManager.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/11.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRequestManager.h"

@interface LRRequestManager ()

@end

static LRRequestManager *requestManager = nil;
@implementation LRRequestManager

+ (LRRequestManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[LRRequestManager alloc] init];
    });
    return requestManager;
}


// 请求
- (void)requestWithMethod:(NSString *)method urlString:(NSString *)url
               parameters:(NSDictionary *)parameters
                    token:(NSString *)token
               completion:(void (^)(NSString *result,NSError *error))aCompletionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:method];
    NSDictionary *headers = nil;
    if ([token isEqualToString:@""]) {
        headers = @{@"content-type": @"application/json",@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]};
    }else {
        headers = @{@"content-type": @"application/json"};
    }
    [request setAllHTTPHeaderFields:headers];
    if (parameters) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    aCompletionBlock([weakself requestTheResultsWithData:data],error);
                                                }];
    [dataTask resume];
}

- (NSString *)requestTheResultsWithData:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
