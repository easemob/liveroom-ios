//
//  LRMainViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRMainViewController.h"
#import "LRRoomListViewController.h"
#import "LRRoomViewController.h"
#import "LRCreateRoomViewController.h"
#import "LRSettingViewController.h"
#import "LRTabBar.h"
#import "LRRoomModel.h"

@interface LRMainViewController () <UITabBarControllerDelegate, LRTabBarDelegate>

@property (nonatomic, strong) LRRoomListViewController *voiceChatRoomListVC;
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

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(roomDidCreated:) name:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:nil];
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
    self.voiceChatRoomListVC = [[LRRoomListViewController alloc] init];
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
    LRCreateRoomViewController *createVC = [[LRCreateRoomViewController alloc] init];
    [self presentViewController:createVC animated:YES completion:nil];
}


- (void)roomDidCreated:(NSNotification *)aNoti {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (aNoti.object) {
        NSDictionary *roomInfo = aNoti.object;
        LRRoomModel *model = [LRRoomModel roomWithDict:roomInfo];
        LRRoomViewController *lrVC = [[LRRoomViewController alloc] initWithUserType:LRUserType_Admin roomModel:model password:roomInfo[@"rtcConfrPassword"]];
        [self presentViewController:lrVC animated:YES completion:nil];
    }
}

@end
