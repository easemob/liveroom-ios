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
#import "LRVoiceRoomHeader.h"
#import "LRVoiceRoomTabbar.h"
#import "LRRoomModel.h"
#import "Headers.h"
#import "LRChatroomMembersViewController.h"

#import "LRChatHelper.h"
#import "LRSpeakHelper.h"

#define kPadding 15
#define kHeaderViewHeight 45
#define kInputViewHeight 64

@interface LRVoiceRoomViewController () <LRVoiceRoomTabbarDelgate> {
    BOOL _chatJoined;
    BOOL _conferenceJoined;
}
@property (nonatomic, assign) LRUserRoleType type;
@property (nonatomic, strong) LRVoiceRoomHeader *headerView;
@property (nonatomic, strong) LRSpeakerViewController *speakerVC;
@property (nonatomic, strong) LRChatViewController *chatVC;
@property (nonatomic, strong) LRVoiceRoomTabbar *inputBar;
@property (nonatomic, strong) LRRoomModel *roomModel;
@property (nonatomic, strong) NSString *password;
@end

@implementation LRVoiceRoomViewController

- (instancetype)initWithUserType:(LRUserRoleType)aType
                       roomModel:(LRRoomModel *)aRoomModel
                        password:(NSString *)aPassword {
    if (self = [super init]) {
        _type = aType;
        _roomModel = aRoomModel;
        _password = aPassword;
        self.speakerVC.roomModel = _roomModel;
        self.chatVC.roomModel = _roomModel;
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
    
    [self joinChatAndConferenceRoom];
}

#pragma mark - subviews
- (void)_setupSubViews {
    self.headerView = [[LRVoiceRoomHeader alloc] initWithTitle:_roomModel.roomname
                                                          info:_roomModel.roomId];
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
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.equalTo(self.headerView);
        make.right.equalTo(self.headerView);
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 + 30));
    }];

    [self.chatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 - 40));
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
                            itemWithImage:[UIImage imageNamed:@"pause"]
                            target:self
                            action:@selector(musicPlayAction)]];
        
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

- (void)joinChatAndConferenceRoom {
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.easemob.liveroom", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LRChatHelper.sharedInstance joinChatroomWithRoomId:weakSelf.roomModel.roomId
                                                 completion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             self->_chatJoined = success;
             dispatch_semaphore_signal(semaphore);
         }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LRSpeakHelper.sharedInstance joinSpeakRoomWithRoomId:weakSelf.roomModel.conferenceId
                                                     password:weakSelf.password
                                                   completion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             self->_conferenceJoined = success;
             dispatch_semaphore_signal(semaphore);
         }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->_chatJoined) {
                [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:weakSelf.roomModel.conferenceId completion:nil];
            }
            
            if (!self->_conferenceJoined) {
                [LRChatHelper.sharedInstance leaveChatroomWithRoomId:weakSelf.roomModel.roomId completion:nil];
            }
            
            if (!self->_conferenceJoined || !self->_chatJoined) {
                [self closeWindowAction];
            }
        });
    });
}


- (void)memberListAction {
    LRChatroomMembersViewController *membersVC = [[LRChatroomMembersViewController alloc] init];
    [self presentViewController:membersVC animated:YES completion:^{
        
    }];
}

- (void)musicPlayAction {
    
}

- (void)shareAction {
    
}

- (void)settingsAction {
    
}

- (void)closeWindowAction {
    // TODO: delete room
    NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/";
    url = [url stringByAppendingString:self.roomModel.roomId];
    [LRRequestManager.sharedInstance requestWithMethod:@"DELETE" urlString:url parameters:nil token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        [NSNotificationCenter.defaultCenter postNotificationName:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:nil];
    }];
    
    
    /*
    if([self.roomModel.owner isEqualToString:LRChatHelper.sharedInstance.currentUser]) {
        NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/";
        url = [url stringByAppendingString:self.roomModel.roomId];
        [LRRequestManager.sharedInstance requestWithMethod:@"DELETE" urlString:url parameters:nil token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
            
        }];
    }
     */
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
        }];
    } else {
        [UIView animateWithDuration:aDuration animations:^{
            self.headerView.alpha = 1;
            self.speakerVC.view.alpha = 1;
        }];
    }
    
    [self.inputBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatVC.view);
        make.right.equalTo(self.chatVC.view);
        make.height.equalTo(@kInputViewHeight);
        make.bottom.equalTo(self.view).offset(isKeyboardShow ? -height : -height - LRSafeAreaBottomHeight);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)likeAction {
    [LRChatHelper.sharedInstance sendLikeToChatroom:_roomModel.roomId completion:nil];
}

- (void)giftAction {
    [LRChatHelper.sharedInstance sendGiftToChatroom:_roomModel.roomId completion:nil];
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
