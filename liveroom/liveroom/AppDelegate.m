//
//  AppDelegate.m
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/3/26.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "AppDelegate.h"
#import "Headers.h"
#import "LRMainViewController.h"
#import "LRLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[LRLogManager shareManager] start];
    LRLog(@"---------------------- init ----------------------");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.blackColor;
    self.window.rootViewController = LRImHelper.sharedInstance.isLoggedIn ?
    [[LRMainViewController alloc] init] : [[LRLoginViewController alloc] init] ;
    [self.window makeKeyAndVisible];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:LR_ACCOUNT_LOGIN_CHANGED
                                               object:nil];
    
    return YES;
}

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL isLogin = [notification.object boolValue];
    self.window.rootViewController = isLogin ?
    [[LRMainViewController alloc] init] : [[LRLoginViewController alloc] init];
}


@end
