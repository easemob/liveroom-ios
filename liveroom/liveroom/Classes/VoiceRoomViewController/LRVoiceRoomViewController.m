//
//  LRVoiceRoomViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVoiceRoomViewController.h"
#import "LRVoiceRoomHeader.h"
#import "Headers.h"

#define kPadding 15
@interface LRVoiceRoomViewController ()
@property (nonatomic, assign) LRUserRoleType type;
@property (nonatomic, strong) LRVoiceRoomHeader *headerView;
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
//    self.view.backgroundColor = [UIColor whiteColor];
    [self _setupSubViews];
    [self _updateHeaderView];
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
        make.height.equalTo(@100);
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
    [self.headerView setupMusicName:@"测试音乐" timer:60];

}

#pragma mark - actions
- (void)memberListAction {
    
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

@end
