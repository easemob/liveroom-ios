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
@property (strong, nonatomic) UITabBar *tcTabBar;

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
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//        [self addChildViewController:nav];
    } else {
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//        [self addChildViewController:viewController];
    }
    
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //
    ////    nav.navigationBar.backgroundColor = [UIColor grayColor];
    //
    //
    //    [self addChildViewController:nav];
    [self addChildViewController:viewController];
}

#pragma mark
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //判断用户是否登陆
//    if (isLogin == NO) {
//        //这里拿到你想要的tabBarItem,这里的方法有很多,还有通过tag值,这里看你的需要了
//        if ([viewController.tabBarItem.title isEqualToString:@"消息"] || [viewController.tabBarItem.title isEqualToString:@"订单"]) {
//            LoginController *vc = [LoginController new];
//            [self presentViewController:vc animated:YES completion:nil];
//            //这里的NO是关键,如果是这个tabBarItem,就不要让他点击进去
//            return NO;
//        }
//    }
    
    NSLog(@"tag---%ld", viewController.tabBarItem.tag);
    
    if (viewController.tabBarItem.tag == 1) {
        LRCreateVoiceChatRoomViewController *createVoiceChatRoom = [[LRCreateVoiceChatRoomViewController alloc] init];
        [self presentViewController:createVoiceChatRoom animated:YES completion:^{
            
        }];
        return NO;
    }
    
    //当然其余的还是要点击进去的
    return YES;
}
@end
