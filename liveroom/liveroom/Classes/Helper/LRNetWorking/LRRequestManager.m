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
               completion:(void (^)(NSDictionary *result,NSError *aError))aCompletionBlock
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

                                                    if (!aCompletionBlock) {
                                                        return ;
                                                    }
                                                    if (error) {
                                                        aCompletionBlock(nil, error);
                                                        return ;
                                                    }
                                                    
                                                    NSDictionary *info = [weakself requestTheResultsWithData:data];
                                                    if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                                                        aCompletionBlock(info, error);
                                                    } else {
                                                        error = [NSError errorWithDomain:info[@"error"] code:[info[@"status"] integerValue] userInfo:nil];
                                                        aCompletionBlock(info, error);
                                                    }
                                                }];
    [dataTask resume];
}

- (NSDictionary *)requestTheResultsWithData:(NSData *)aData
{
    NSString *str = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

@end
