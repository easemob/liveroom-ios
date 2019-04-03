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
@end

@implementation LRVoiceRoomViewController

- (instancetype)initWithUserType:(LRUserRoleType)aType {
    if (self = [super init]) {
        _type = aType;
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
    self.headerView = [[LRVoiceRoomHeader alloc] initWithTitle:@"测试ABC" info:@"dujiepeng"];
    self.headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPadding);
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@160);
    }];
}

- (void)_updateHeaderView {
    NSMutableArray *itemAry = [NSMutableArray array];
    if (_type == LRUserType_Admin) {
        [itemAry addObject:[LRVoiceRoomHeaderItem itemWithImage:[UIImage imageNamed:@"userList"] action:nil]];
        [itemAry addObject:[LRVoiceRoomHeaderItem itemWithImage:[UIImage imageNamed:@"musicList"] action:nil]];
        [itemAry addObject:[LRVoiceRoomHeaderItem itemWithImage:[UIImage imageNamed:@"share"] action:nil]];
        [itemAry addObject:[LRVoiceRoomHeaderItem itemWithImage:[UIImage imageNamed:@"settings"] action:nil]];
        [itemAry addObject:[LRVoiceRoomHeaderItem itemWithImage:[UIImage imageNamed:@"close"] action:nil]];
    }else {
        
    }
    
    [self.headerView setActionList:itemAry];
}

@end
