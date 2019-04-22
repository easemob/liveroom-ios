//
//  LRRoomViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRRoomViewController.h"
#import "LRSpeakViewController.h"
#import "LRChatViewController.h"
#import "LRVoiceRoomHeader.h"
#import "LRVoiceRoomTabbar.h"
#import "LRRoomModel.h"
#import "Headers.h"
#import "LRRoomInfoViewController.h"

#import "UIViewController+LRAlert.h"

#import "LRChatHelper.h"
#import "LRSpeakHelper.h"

#define kPadding 15
#define kHeaderViewHeight 45
#define kInputViewHeight 64

@interface LRRoomViewController () <LRVoiceRoomTabbarDelgate, LRSpeakHelperDelegate> {
    BOOL _chatJoined;
    BOOL _conferenceJoined;
    BOOL _chatLeave;
    BOOL _conferenceLeave;
}
@property (nonatomic, assign) LRUserRoleType type;
@property (nonatomic, strong) LRVoiceRoomHeader *headerView;
@property (nonatomic, strong) LRSpeakViewController *speakerVC;
@property (nonatomic, strong) LRChatViewController *chatVC;
@property (nonatomic, strong) LRVoiceRoomTabbar *inputBar;
@property (nonatomic, strong) LRRoomModel *roomModel;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) UIButton *applyOnSpeakBtn;
@end

@implementation LRRoomViewController

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
    [self regieterNotifiers];
    
    [self _setupSubViews];
    [self _updateHeaderView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatTapAction:)];
    [self.chatVC.view addGestureRecognizer:tap];
    [self joinChatAndConferenceRoom];
}

- (void)regieterNotifiers {
    [LRSpeakHelper.sharedInstance addDeelgate:self delegateQueue:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(showRequestInfo:)
                                               name:LR_Notification_Receive_OnSpeak_Request
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receiveRequestReject:)
                                               name:LR_Notification_Receive_OnSpeak_Reject
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receiveRequestAgreed:)
                                               name:LR_Notification_UI_ChangeRoleToSpeaker
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changeToAudience:)
                                               name:LR_Notification_UI_ChangeRoleToAudience
                                             object:nil];
}

// 收到上麦申请
- (void)showRequestInfo:(NSNotification *)aNoti  {
    NSString *username = aNoti.object;
    if (username) {
        NSString *info = [NSString stringWithFormat:@"%@申请上麦", username];
        LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"收到上麦申请" info:info];
        LRAlertAction *agreed = [LRAlertAction alertActionTitle:@"同意" callback:^(LRAlertController * _Nonnull alertController) {
            [LRSpeakHelper.sharedInstance setupUserToSpeaker:username];
        }];
        
        LRAlertAction *reject = [LRAlertAction alertActionTitle:@"拒绝" callback:^(LRAlertController * _Nonnull alertController) {
            [LRSpeakHelper.sharedInstance forbidUserOnSpeaker:username];
        }];
        [alert addAction:agreed];
        [alert addAction:reject];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 上麦申请被同意
- (void)receiveRequestAgreed:(NSNotification *)aNoti {
    self.applyOnSpeakBtn.hidden = YES;
    self.applyOnSpeakBtn.selected = NO;
}

// 上麦申请被拒绝
- (void)receiveRequestReject:(NSNotification *)aNoti {
    NSDictionary *dict = aNoti.object;
    if (dict.count > 0) {
        if ([dict.allKeys.firstObject isEqualToString:self.roomModel.roomId]) {
            self.applyOnSpeakBtn.selected = NO;
            self.applyOnSpeakBtn.hidden = NO;
            [self showTipsAlertWithTitle:@"提示 Tip" info:@"申请上麦被拒绝"];
        }
    }
}

- (void)changeToAudience:(NSNotification *)aNoti {
    self.applyOnSpeakBtn.hidden = NO;
    self.applyOnSpeakBtn.selected = NO;
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
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 + 80));
    }];

    [self.chatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 - 90));
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
    
    if (!self.isOwner) {
        [self.view addSubview:self.applyOnSpeakBtn];
        [self.applyOnSpeakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@46);
            make.bottom.equalTo(self.chatVC.view);
            make.right.equalTo(self.chatVC.view);
        }];
    }
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
                return ;
            }
            
            if (self.isOwner) { // 群主自动上麦
                [LRSpeakHelper.sharedInstance setupMySelfToSpeaker];
            }
        });
    });
}

- (void)memberListAction {
    LRRoomInfoViewController *membersVC = [[LRRoomInfoViewController alloc] init];
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
    if (self.isOwner) {
        NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/";
        url = [url stringByAppendingString:self.roomModel.roomId];
        [LRRequestManager.sharedInstance requestWithMethod:@"DELETE" urlString:url parameters:nil token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
            [NSNotificationCenter.defaultCenter postNotificationName:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:nil];
        }];
    }
    
    [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:self.roomModel.conferenceId completion:nil];
    [LRChatHelper.sharedInstance leaveChatroomWithRoomId:self.roomModel.roomId completion:nil];
    
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

- (void)applyOnSpeak:(UIButton *)btn {
    if (self.applyOnSpeakBtn.selected == YES) {
        return;
    }
    self.applyOnSpeakBtn.selected = YES;
    [LRSpeakHelper.sharedInstance requestOnSpeaker:self.roomModel completion:^(NSString * _Nonnull errorInfo, BOOL success)
    {
        if (!success) {
            self.applyOnSpeakBtn.selected = NO;
            [self showErrorAlertWithTitle:@"错误 Error" info:errorInfo];
        }
    }];
}

#pragma mark - getter

- (BOOL)isOwner {
    return [self.roomModel.owner isEqualToString:kCurrentUsername];
}

- (UIButton *)applyOnSpeakBtn {
    if (!_applyOnSpeakBtn) {
        _applyOnSpeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyOnSpeakBtn.backgroundColor = [UIColor whiteColor];
        [_applyOnSpeakBtn setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        [_applyOnSpeakBtn setImage:[UIImage imageNamed:@"unmic"] forState:UIControlStateSelected];
        _applyOnSpeakBtn.layer.masksToBounds = YES;
        _applyOnSpeakBtn.layer.cornerRadius = 23;
        [_applyOnSpeakBtn addTarget:self action:@selector(applyOnSpeak:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyOnSpeakBtn;
}


- (LRSpeakViewController *)speakerVC {
    if (!_speakerVC) {
        _speakerVC = [[LRSpeakViewController alloc] init];
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
