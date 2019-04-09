//
//  LRVoiceRoomViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVoiceRoomViewController.h"
#import "LRSpeakerViewController.h"
#import "LRChatViewController.h"
#import "LRMusicPlayerHelper.h"
#import "LRVoiceRoomHeader.h"
#import "LRVoiceRoomTabbar.h"
#import "Headers.h"
#import "LRChatroomMembersViewController.h"


#define kPadding 15
#define kHeaderViewHeight 100
#define kInputViewHeight 64

@interface LRVoiceRoomViewController () <LRVoiceRoomTabbarDelgate>
@property (nonatomic, assign) LRUserRoleType type;
@property (nonatomic, strong) LRVoiceRoomHeader *headerView;
@property (nonatomic, strong) LRSpeakerViewController *speakerVC;
@property (nonatomic, strong) LRChatViewController *chatVC;
@property (nonatomic, strong) LRVoiceRoomTabbar *inputBar;
@property (nonatomic, strong) NSString *roomName;
@end

@implementation LRVoiceRoomViewController

- (instancetype)initWithUserType:(LRUserRoleType)aType roomName:(NSString *)aRoomName {
    if (self = [super init]) {
        _type = aType;
        _roomName = aRoomName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self _setupSubViews];
    [self _updateHeaderView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatTapAction:)];
    [self.chatVC.view addGestureRecognizer:tap];
}

- (void)todo {
    // get play list
    NSMutableArray *ary = [NSMutableArray array];
    
    LRMusicItem *item1 = [[LRMusicItem alloc] init];
    item1.itemName = @"test1";
    item1.totalTime = 60;
    [ary addObject:item1];
    
    LRMusicItem *item2 = [[LRMusicItem alloc] init];
    item2.itemName = @"test2";
    item2.totalTime = 90;
    [ary addObject:item2];
    
    LRMusicItem *item3 = [[LRMusicItem alloc] init];
    item3.itemName = @"test3";
    item3.totalTime = 120;
    [ary addObject:item3];
    
    [LRMusicPlayerHelper sharedInstance].playList = ary;
    [[LRMusicPlayerHelper sharedInstance] play];
}

#pragma mark - subviews
- (void)_setupSubViews {
    self.headerView = [[LRVoiceRoomHeader alloc] initWithTitle:self.roomName info:@"dujiepeng"];
    self.headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPadding);
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@kHeaderViewHeight);
    }];
    
    [self.view addSubview:self.speakerVC.view];
    [self addChildViewController:self.speakerVC];
    
    [self.view addSubview:self.chatVC.view];
    [self addChildViewController:self.chatVC];
    
    [self.view addSubview:self.inputBar];
    
    [self.speakerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.headerView);
        make.right.equalTo(self.headerView);
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight) / 2 + 30));
    }];

    [self.chatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight) / 2 - 40));
        make.left.equalTo(self.speakerVC.view);
        make.right.equalTo(self.speakerVC.view);
        make.bottom.equalTo(self.inputBar.mas_top);
    }];

    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatVC.view.mas_bottom);
        make.left.equalTo(self.chatVC.view);
        make.right.equalTo(self.chatVC.view);
        make.height.equalTo(@kInputViewHeight);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight);
    }];
}

- (void)_updateHeaderView {
    NSMutableArray *itemAry = [NSMutableArray array];
    if (_type == LRUserType_Admin) {
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"userList"]
                            target:self
                            action:@selector(memberListAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"musicList"]
                            target:self
                            action:@selector(musicPlayListAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"share"]
                            target:self
                            action:@selector(shareAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"settings"]
                            target:self
                            action:@selector(settingsAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"close"]
                            target:self
                            action:@selector(closeWindowAction)]];
    }else {
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"userList"]
                            target:self
                            action:@selector(memberListAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"share"]
                            target:self
                            action:@selector(shareAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"settings"]
                            target:self
                            action:@selector(settingsAction)]];
        
        [itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"close"]
                            target:self
                            action:@selector(closeWindowAction)]];
    }
    
    [self.headerView setActionList:itemAry];
}

#pragma mark - actions
- (void)memberListAction {
    LRChatroomMembersViewController *membersVC = [[LRChatroomMembersViewController alloc] init];
    [self presentViewController:membersVC animated:YES completion:^{
        
    }];
}

- (void)musicPlayListAction {
    
}

- (void)shareAction {
    
}

- (void)settingsAction {
    
}

- (void)closeWindowAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chatTapAction:(UITapGestureRecognizer *)tapGr {
    [self.view endEditing:YES];
}

#pragma mark - LRVoiceRoomTabbarDelgate
- (void)inputViewHeightDidChanged:(CGFloat)aChangeHeight
                         duration:(CGFloat)aDuration
                             show:(BOOL)isKeyboardShow{
    CGFloat height = self.view.bounds.size.height - aChangeHeight;

    if (isKeyboardShow) {
        [UIView animateWithDuration:aDuration animations:^{
            self.headerView.alpha = 0;
            self.speakerVC.view.alpha = 0;
            self.speakerVC.view.frame = CGRectInset(self.speakerVC.view.frame, -80, -80);
        }];
    } else {
        [UIView animateWithDuration:aDuration animations:^{
            self.headerView.alpha = 1;
            self.speakerVC.view.alpha = 1;
            self.speakerVC.view.frame = CGRectInset(self.speakerVC.view.frame, 80, 80);
        }];
    }
    
    [self.inputBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatVC.view);
        make.right.equalTo(self.chatVC.view);
        make.height.equalTo(@kInputViewHeight);
        make.bottom.equalTo(self.view).offset(-height);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)likeAction {
    NSLog(@"like action");
}

- (void)giftAction {
    NSLog(@"gift action");
}

- (void)sendAction:(NSString *)aText {
    [self.chatVC sendText:aText];
}

#pragma mark - getter
- (LRSpeakerViewController *)speakerVC {
    if (!_speakerVC) {
        _speakerVC = [[LRSpeakerViewController alloc] init];
    }
    return _speakerVC;
}

- (LRChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [[LRChatViewController alloc] init];
    }
    return _chatVC;
}

- (LRVoiceRoomTabbar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[LRVoiceRoomTabbar alloc] init];
        _inputBar.delegate = self;
    }
    return _inputBar;
}


@end
