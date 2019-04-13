//
//  LRMainViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRMainViewController.h"
#import "LRVoiceChatRoomListViewController.h"
#import "LRVoiceRoomViewController.h"
#import "LRCreateVoiceChatRoomViewController.h"
#import "LRSettingViewController.h"
#import "LRTabBar.h"


@interface LRMainViewController () <UITabBarControllerDelegate, LRTabBarDelegate>

@property (nonatomic, strong) LRVoiceChatRoomListViewController *voiceChatRoomListVC;
@property (nonatomic, strong) LRSettingViewController *settingVC;

@end

@implementation LRMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupSubviews];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(roomDidCreated:) name:LR_NOTIFICATION_AFTER_CREATED_ROOM object:nil];
}

- (void)_setupSubviews
{
    LRTabBar *tabBar = [[LRTabBar alloc] initWithFrame:CGRectMake(0, LRWindowHeight - LRSafeAreaBottomHeight - 49, LRWindowWidth, 49)];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [self.view bringSubviewToFront:tabBar];
    
    [self _setupChildrenViewController];
}

- (void)_setupChildrenViewController
{
    self.voiceChatRoomListVC = [[LRVoiceChatRoomListViewController alloc] init];
    self.settingVC = [[LRSettingViewController alloc] init];
    self.viewControllers = @[self.voiceChatRoomListVC,self.settingVC];
}

#pragma mark - LRTabBarDelegate
- (void)tabBar:(LRTabBar *)tabBar clickViewAction:(NSInteger)tag
{
    if (tag != 101) {
        if (tag == 100) {
            self.selectedIndex = tag - 100;
        } else {
            self.selectedIndex = tag - 101;
        }
        return;
    }
    //是模态视图
    LRCreateVoiceChatRoomViewController *createVC = [[LRCreateVoiceChatRoomViewController alloc] init];
    [self presentViewController:createVC animated:YES completion:nil];
}


- (void)roomDidCreated:(NSNotification *)aNoti {
    NSDictionary *roomInfo = aNoti.object;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    LRVoiceRoomViewController *lrVC = [[LRVoiceRoomViewController alloc] initWithUserType:LRUserType_Admin roomInfo:roomInfo];
    [self presentViewController:lrVC animated:YES completion:nil];
}

@end
