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
#import "LRRoomSettingViewController.h"
#import "UIViewController+LRAlert.h"

#import "LRChatHelper.h"
#import "LRSpeakHelper.h"
#import <AVFoundation/AVFoundation.h>

#define kPadding 15
#define kHeaderViewHeight 45
#define kInputViewHeight 64

@interface LRRoomViewController () <LRVoiceRoomTabbarDelgate, LRSpeakHelperDelegate, EMChatroomManagerDelegate> {
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
@property (nonatomic, strong) NSMutableArray *itemAry;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isKickedOut;
@property (nonatomic, strong) NSString *errorInfo;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[EMClient sharedClient].roomManager removeDelegate:self];
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
                                               name:LR_Receive_OnSpeak_Request_Notification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receiveRequestReject:)
                                               name:LR_Receive_OnSpeak_Reject_Notification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receiveRequestAgreed:)
                                               name:LR_UI_ChangeRoleToSpeaker_Notification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changeToAudience:)
                                               name:LR_UI_ChangeRoleToAudience_Notification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(chatroomDidDestory:)
                                               name:LR_Receive_Conference_Destory_Notification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didLoginOtherDevice:)
                                               name:LR_Did_Login_Other_Device_Notification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(backChatroom:)
                                               name:LR_Back_Chatroom_Notification
                                             object:nil];
}

// 收到上麦申请
- (void)showRequestInfo:(NSNotification *)aNoti  {
    NSDictionary *dict = aNoti.object;
    NSString *username = dict[@"from"];
    NSString *confid = dict[@"confid"];
    if (![confid isEqualToString:self.roomModel.conferenceId]) {
        return;
    }
    
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    if (options.isAllowApplyAsSpeaker) {
        [LRSpeakHelper.sharedInstance setupUserToSpeaker:username];
    }else {
        if (username) {
            NSString *info = [NSString stringWithFormat:@"收到%@申请上麦", username];
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
}

// 上麦申请被同意
- (void)receiveRequestAgreed:(NSNotification *)aNoti {
    self.applyOnSpeakBtn.hidden = YES;
    self.applyOnSpeakBtn.selected = NO;
    
}

// 上麦申请被拒绝
- (void)receiveRequestReject:(NSNotification *)aNoti {
    NSDictionary *dict = aNoti.object;
    NSString *confid = dict[@"confid"];
    if (![confid isEqualToString:self.roomModel.conferenceId]) {
        return;
    }
    self.applyOnSpeakBtn.selected = NO;
    self.applyOnSpeakBtn.hidden = NO;
    [self showTipsAlertWithTitle:@"提示 Tip" info:@"申请上麦被拒绝"];
}

- (void)didLoginOtherDevice:(NSNotification *)aNoti {
    [self closeWindowAction];
}

- (void)changeToAudience:(NSNotification *)aNoti {
    self.applyOnSpeakBtn.hidden = NO;
    self.applyOnSpeakBtn.selected = NO;
}

- (void)chatroomDidDestory:(NSNotification *)aNoti {
    NSString *confId = (NSString *)aNoti.object;
    if ([confId isEqualToString:self.roomModel.conferenceId]) {
        [self closeWindowAction];
    }
}

- (void)backChatroom:(NSNotification *)aNoti {
    [self leaveChatroomAndKickedOutNotification:@"您被房主移出房间"];
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
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 + 140));
    }];

    [self.chatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speakerVC.view);
        make.right.equalTo(self.speakerVC.view);
        make.bottom.equalTo(self.inputBar.mas_top);
        make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 - 90 - 60));
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
    self.itemAry = [NSMutableArray array];
    if (_type == LRUserType_Admin) {
        NSString *imageName;
        if ([LRRoomOptions sharedOptions].isAutomaticallyTurnOnMusic) {
            imageName = @"musicalpause";
            self.isSelect = YES;
        } else {
            imageName = @"musicalplay";
            self.isSelect = NO;
        }
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImageName:imageName
                            target:self
                            action:@selector(musicPlayAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"members"]
                            target:self
                            action:@selector(memberListAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"share-1"]
                            target:self
                            action:@selector(shareAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"setting"]
                            target:self
                            action:@selector(settingsAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"closed"]
                            target:self
                            action:@selector(closeWindowAction)]];
    }else {
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"members"]
                            target:self
                            action:@selector(memberListAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"share-1"]
                            target:self
                            action:@selector(shareAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"setting"]
                            target:self
                            action:@selector(settingsAction)]];
        
        [self.itemAry addObject:[LRVoiceRoomHeaderItem
                            itemWithImage:[UIImage imageNamed:@"closed"]
                            target:self
                            action:@selector(closeWindowAction)]];
    }
    
    [self.headerView setActionList:self.itemAry];
}

#pragma mark - actions

- (void)joinChatAndConferenceRoom {
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"正在加入房间..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.easemob.liveroom", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LRChatHelper.sharedInstance joinChatroomWithCompletion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             self->_chatJoined = success;
             dispatch_semaphore_signal(semaphore);
         }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [LRSpeakHelper.sharedInstance joinSpeakRoomWithConferenceId:weakSelf.roomModel.conferenceId
                                                     password:weakSelf.password
                                                   completion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             self->_conferenceJoined = success;
             self->_errorInfo = errorInfo;
             dispatch_semaphore_signal(semaphore);
         }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!self->_chatJoined) {
                [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:weakSelf.roomModel.conferenceId completion:nil];
            }
            
            if (!self->_conferenceJoined) {
                [LRChatHelper.sharedInstance leaveChatroomWithCompletion:nil];
            }
            
            if (!self->_conferenceJoined || !self->_chatJoined) {
                [self closeWindowAction];
                return ;
            }
            
            if (self.isOwner) { // 群主自动上麦
                [LRSpeakHelper.sharedInstance setupRoomType:self.roomModel.roomType];
                [LRSpeakHelper.sharedInstance setupMySelfToSpeaker];
                // 如果是主持模式，管理员直接持麦
                if (self.roomModel.roomType == LRRoomType_Host) {
                    [LRSpeakHelper.sharedInstance setupSpeakerMicOn:kCurrentUsername];
                }
                if ([LRRoomOptions sharedOptions].isAutomaticallyTurnOnMusic) {
                    [LRSpeakHelper.sharedInstance setAudioPlay:YES];
                }
            }
        });
    });
}

- (void)memberListAction {
    LRRoomInfoViewController *membersVC = [[LRRoomInfoViewController alloc] init];
    membersVC.model = self.roomModel;
    [self presentViewController:membersVC animated:YES completion:^{
        
    }];
}

- (void)musicPlayAction{
    if (self.isOwner) {
        UIButton *button = [self.itemAry firstObject];
        if (self.isSelect) {
            [LRChatHelper.sharedInstance sendMessageFromNoti:@"停止歌曲"];
            [self musicPlayButton:button ImageName:@"musicalplay" select:NO setAudioPlay:NO];
        } else {
            [LRChatHelper.sharedInstance sendMessageFromNoti:@"开始歌曲"];
            [self musicPlayButton:button ImageName:@"musicalpause" select:YES setAudioPlay:YES];
        }
    }
}

- (void)musicPlayButton:(UIButton *)button
              ImageName:(NSString *)imageName
                 select:(BOOL)isSelect
           setAudioPlay:(BOOL)isPlay
{
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.isSelect = isSelect;
    [[LRSpeakHelper sharedInstance] setAudioPlay:isPlay];
}

- (void)shareAction {
    //是模态视图
    NSString *str = [NSString stringWithFormat:@"房间: %@\n房主: %@\n密码: %@\n下载地址: %@", self.roomModel.roomname, self.roomModel.owner, _password ,@"https://www.easemob.com"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    
    [self showTipsAlertWithTitle:@"内容已复制" info:@"已将房间信息复制到粘贴板，\n请您直接粘贴到要分享的软件中。"];
}

- (void)settingsAction {
    LRRoomSettingViewController *settingVC = [[LRRoomSettingViewController alloc] init];
    settingVC.rommPassword = _password;
    settingVC.speakerLimited = 6;
    settingVC.model = _roomModel;
    [self presentViewController:settingVC animated:YES completion:nil];
}

- (void)closeWindowAction {
    if (self.isOwner)
    {
        NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/";
        url = [url stringByAppendingString:self.roomModel.roomId];
        [LRRequestManager.sharedInstance requestWithMethod:@"DELETE"
                                                 urlString:url
                                                parameters:nil
                                                     token:nil
                                                completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
        {
            [NSNotificationCenter.defaultCenter postNotificationName:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:nil];
        }];
    }
    
    [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:self.roomModel.conferenceId completion:nil];
    [LRChatHelper.sharedInstance leaveChatroomWithCompletion:nil];
    if ([LRRoomOptions sharedOptions].isAutomaticallyTurnOnMusic) {
        [EMClient.sharedClient.conferenceManager stopAudioMixing];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self->_errorInfo isEqualToString:@"Password is illegal"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LR_Join_Conference_Password_Error_Notification object:nil];
        }
    }];
}

- (void)chatTapAction:(UITapGestureRecognizer *)tapGr {
    [self.view endEditing:YES];
}

#pragma mark - EMChatroomManagerDelegate
- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason
{
    self.isKickedOut = YES;
    if (aReason == EMChatroomBeKickedReasonBeRemoved) {
        [self leaveChatroomAndKickedOutNotification:@"您被房主移出房间"];
    } else if (aReason == EMChatroomBeKickedReasonDestroyed) {
        [self leaveChatroomAndKickedOutNotification:@"房间被销毁"];
    }
}

- (void)leaveChatroomAndKickedOutNotification:(NSString *)aReason
{
    [LRSpeakHelper.sharedInstance leaveSpeakRoomWithRoomId:self.roomModel.conferenceId completion:nil];
    [LRChatHelper.sharedInstance leaveChatroomWithCompletion:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_Kicked_Out_Chatroom_Notification object:aReason];
    }];
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
            [self.chatVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 + 30));
            }];
        }];
    } else {
        [UIView animateWithDuration:aDuration animations:^{
            self.headerView.alpha = 1;
            self.speakerVC.view.alpha = 1;
            [self.chatVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((LRWindowHeight - LRSafeAreaTopHeight - kHeaderViewHeight - kInputViewHeight - LRSafeAreaBottomHeight) / 2 - 90 - 60));
            }];
        }];
    }
    
    [self.inputBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatVC.view);
        make.right.equalTo(self.chatVC.view);
        make.height.equalTo(@kInputViewHeight);
        make.bottom.equalTo(self.view).offset(isKeyboardShow ? -height : -height - LRSafeAreaBottomHeight);
    }];
    
    [self.view layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:LR_ChatView_Tableview_Roll_Notification object:nil];
}

- (void)likeAction {
    [_chatVC sendLike];
}

- (void)giftAction {
    [_chatVC sendGift];
}

- (void)sendAction:(NSString *)aText {
    [self.chatVC sendText:aText];
}

- (void)applyOnSpeak:(UIButton *)btn {
    if (self.applyOnSpeakBtn.selected == YES) {
        return;
    }
    
    if (self.speakerVC.memberList.count >= 6) {
        [self showErrorAlertWithTitle:@"申请失败" info:@"当前主播数量已满"];
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

//- (void)dealloc
//{
//    LRSpeakHelper.sharedInstance.roomModel = nil;
//}

@end
