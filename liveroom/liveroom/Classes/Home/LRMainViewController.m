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

@interface LRMainViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) LRVoiceChatRoomListViewController *voiceChatRoomListVC;
@property (nonatomic, strong) LRCreateVoiceChatRoomViewController *createVoiceChatRoomVC;
@property (nonatomic, strong) LRSettingViewController *settingVC;
@property (strong, nonatomic) UITabBar *lrTabBar;

@end

@implementation LRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voiceChatRoomListVC = [[LRVoiceChatRoomListViewController alloc] init];
    self.voiceChatRoomListVC.tabBarItem.tag = 0;
    [self addChildViewControllerTitle:@"房间" image:nil viewController:_voiceChatRoomListVC];
    self.createVoiceChatRoomVC = [[LRCreateVoiceChatRoomViewController alloc] init];
    self.createVoiceChatRoomVC.tabBarItem.tag = 1;
    [self addChildViewControllerTitle:nil image:@"add" viewController:_createVoiceChatRoomVC];
    self.settingVC = [[LRSettingViewController alloc] init];
    self.settingVC.tabBarItem.tag = 2;
    [self addChildViewControllerTitle:@"设置" image:nil viewController:_settingVC];
//    self.tcTabBar.delegate = self;
    self.delegate = self;
}

- (void)addChildViewControllerTitle:(NSString *)title image:(NSString *)image viewController:(UIViewController *)viewController
{
    
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    // 解决图片变蓝的问题
    UIImage *originalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@HL",image]];
    viewController.tabBarItem.selectedImage = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [viewController setTitle:title];
    
    if (viewController.tabBarItem.tag != 1) {
        viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(-10,-15);
        [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont systemFontOfSize:16], NSFontAttributeName,
                                                           nil,NSForegroundColorAttributeName,
                                                           nil] forState:UIControlStateNormal];
        [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    } else {
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    [self addChildViewController:viewController];
}

#pragma mark
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController.tabBarItem.tag == 1) {
        LRCreateVoiceChatRoomViewController *createVoiceChatRoom = [[LRCreateVoiceChatRoomViewController alloc] init];
        [self presentViewController:createVoiceChatRoom animated:YES completion:^{
            
        }];
        return NO;
    }
    return YES;
}
@end
