//
//  LRRequestManager.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/11.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRequestManager.h"

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

// get
- (void)getNetworkRequestWithUrl:(NSString *)url token:(NSString *)token completion:(void (^)(NSString *, NSError *))aCompletionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    NSDictionary *headers = nil;
    if (token) {
        headers = @{@"content-type": @"application/json",@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]};
    } else {
        headers = @{@"content-type": @"application/json"};
    }
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    aCompletionBlock([weakself requestTheResultsWithData:data],error);
                                                }];
    [dataTask resume];
}

// post
- (void)postNetworkRequestWithUrl:(NSString *)url requestBody:(NSDictionary *)requestBody token:(NSString *)token completion:(void (^)(NSString *result,NSError *error))aCompletionBlock
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSDictionary *headers = nil;
    if ([token isEqualToString:@""]) {
        headers = @{@"content-type": @"application/json",@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]};
    } else {
        headers = @{@"content-type": @"application/json"};
    }
    [request setAllHTTPHeaderFields:headers];
    if (requestBody) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:nil];
        [request setHTTPBody:postData];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSLog(@"response---%@,error---%@", response,error);
                                                    aCompletionBlock([weakself requestTheResultsWithData:data],error);
                                                }];
    [dataTask resume];
}

// delete
- (void)deleteNetworkRequestWithUrl:(NSString *)url token:(NSString *)token completion:(void (^)(NSString *result,NSError *error))aCompletionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    NSDictionary *headers = nil;
    if (token) {
        headers = @{@"content-type": @"application/json",@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]};
    } else {
        headers = @{@"content-type": @"application/json"};
    }
    [request setAllHTTPHeaderFields:headers];
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
