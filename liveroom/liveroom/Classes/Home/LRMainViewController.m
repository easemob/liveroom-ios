//
//  LRMainViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRMainViewController.h"
#import "LRVoiceChatRoomListViewController.h"
#import "LRCreateVoiceChatRoomViewController.h"
#import "LRSettingViewController.h"
#import "LRTabBar.h"


@interface LRMainViewController () <UITabBarControllerDelegate, LRTabBarDelegate>

@property (nonatomic, strong) LRVoiceChatRoomListViewController *voiceChatRoomListVC;
@property (nonatomic, strong) LRCreateVoiceChatRoomViewController *createVoiceChatRoomVC;
@property (nonatomic, strong) LRSettingViewController *settingVC;
@property (strong, nonatomic) LRTabBar *lrTabBar;

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

}

- (void)_setupSubviews
{
    self.lrTabBar = [[LRTabBar alloc] initWithFrame:CGRectMake(0, LRWindowHeight - LRSafeAreaBottomHeight - 49, LRWindowWidth, 49)];
    self.lrTabBar.delegate = self;
    [self.view addSubview:self.lrTabBar];
    [self.view bringSubviewToFront:self.lrTabBar];
    
    [self _setupChildrenViewController];
}

- (void)_setupChildrenViewController
{
    self.createVoiceChatRoomVC = [[LRCreateVoiceChatRoomViewController alloc] init];
    NSMutableArray * childVCArr = [NSMutableArray arrayWithArray:@[@"LRVoiceChatRoomListViewController",@"LRSettingViewController"]];
    for (NSInteger i = 0; i < childVCArr.count; i++) {
        NSString *childVCName = childVCArr[i];
        UIViewController *vc = [[NSClassFromString(childVCName) alloc] init];
        [childVCArr replaceObjectAtIndex:i withObject:vc];
    }
    self.viewControllers = childVCArr;
}

#pragma mark - LRTabBarDelegate
- (void)tabBar:(LRTabBar *)tabBar clickViewAction:(LRItemType)type
{
    if (type != LRItemTypeMiddle) {
        if (type == LRItemTypeLeft) {
            self.selectedIndex = type - LRItemTypeLeft;
        } else {
            self.selectedIndex = type - LRItemTypeMiddle;
        }
        return;
    }
    //是模态视图
    [self presentViewController:self.createVoiceChatRoomVC animated:YES completion:nil];
}

@end
