//
//  LRSpeakViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakViewController.h"
#import "LRVolumeView.h"
#import "LRSpeakerCell.h"
#import "LRSpeakerEmptyCell.h"
#import "LRSpeakerTypeView.h"
#import "LRSpeakHelper.h"
#import "LRRoomModel.h"
#import "LRSpeakerCellModel.h"
#import "Headers.h"

#define kMaxSpeakerCount 6

extern NSString * const ON_MIC_EVENT_NAME;
extern NSString * const OFF_MIC_EVENT_NAME;
extern NSString * const TALK_EVENT_NAME;
extern NSString * const ARGUMENT_EVENT_NAME;
extern NSString * const UN_ARGUMENT_EVENT_NAME;
extern NSString * const DISCONNECT_EVENT_NAME;

@interface LRSpeakViewController () <UITableViewDelegate, UITableViewDataSource, LRSpeakHelperDelegate>

@property (nonatomic, strong) LRSpeakerTypeView *headerView;
@property (nonatomic, strong) NSMutableArray *dataAry;

@end

@implementation LRSpeakViewController

- (void)dealloc {
    NSLog(@" ---- lrSPVC - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [LRSpeakHelper.sharedInstance addDeelgate:self delegateQueue:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self _setupSubViews];
    LRSpeakHelper.sharedInstance.roomModel = _roomModel;
    [self.headerView setType:_roomModel.roomType];
    for (int i = 0; i < kMaxSpeakerCount; i++) {
        LRSpeakerCellModel *model = [[LRSpeakerCellModel alloc] init];
        [self.dataAry addObject:model];
    }
    
    [self.tableView reloadData];
}

- (void)_setupSubViews {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.equalTo(@40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - table view delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;
    LRSpeakerCellModel *model = self.dataAry[indexPath.row];
    if (model.username && model.username.length > 0) {
        cell = [LRSpeakerCell speakerCellWithType:self.roomModel.roomType
                                        tableView:tableView
                                        cellModel:model];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerEmptyCell"];
        if (!cell) {
            cell = [[LRSpeakerEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerEmptyCell"];
        }
    }
    return cell;
}

#pragma mark - Actions
// 添加speaker
- (void)addMemberToDataAry:(NSString *)aMember
                  streamId:(NSString *)aStreamId
                      mute:(BOOL)isMute
                     admin:(BOOL)isAdmin{
    @synchronized (self.dataAry) {
        NSLog(@"---- 用户上麦 ---- %@",aMember);
        LRSpeakerCellModel *nModel = nil;
        for (LRSpeakerCellModel *model in self.dataAry) {
            if ([model.username isEqualToString:@""]) {
                nModel = model; // 取第一个空的cell赋值
                break;
            }
        }
        if (nModel) {
            nModel.username = aMember;
            nModel.type = self.roomModel.roomType;
            nModel.streamId = aStreamId;
            nModel.isAdmin = isAdmin;
            nModel.isOwner = [self.roomModel.owner isEqualToString:kCurrentUsername];
            nModel.isMyself = [aMember isEqualToString:kCurrentUsername];
            nModel.speakOn = !isMute;
            nModel.argumentOn = self.roomModel.roomType == LRRoomType_Monopoly ? YES : NO;
            nModel.unArgumentOn = NO;
        }
        if (isAdmin) {
            [self.dataAry exchangeObjectAtIndex:[self.dataAry indexOfObject:nModel] withObjectAtIndex:0];
        }
        [self.tableView reloadData];
    }
}

// 删除speaker
- (void)removeMemberFromDataAry:(NSString *)aMemeber {
    LRSpeakerCellModel *dModel = nil;
    for (LRSpeakerCellModel *model in self.dataAry) {
        if ([model.username isEqualToString:aMemeber]) {
            dModel = model;
            break;
        }
    }
    if (dModel) {
        [self.dataAry removeObject:dModel];
        [self.dataAry addObject:[[LRSpeakerCellModel alloc] init]];
    }
    [self.tableView reloadData];
}

// cell上按钮点击事件
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:ON_MIC_EVENT_NAME]) {
        [LRSpeakHelper.sharedInstance muteMyself:NO];
    }
    
    if ([eventName isEqualToString:OFF_MIC_EVENT_NAME]) {
        [LRSpeakHelper.sharedInstance muteMyself:YES];
    }
    
    if ([eventName isEqualToString:TALK_EVENT_NAME]) {
        LRSpeakerCellModel *model = userInfo.allValues.firstObject;
        NSString *username = model.username;
        [LRSpeakHelper.sharedInstance setupSpeakerMicOn:username];
    }
    
    if ([eventName isEqualToString:ARGUMENT_EVENT_NAME]) {
        LRSpeakerCellModel *model = userInfo.allValues.firstObject;
        __block NSString *username = model.username;
        [LRSpeakHelper.sharedInstance argumentMic:self.roomModel.roomId
                                       completion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             if (success) {
                 [LRSpeakHelper.sharedInstance setupSpeakerMicOn:username];
             }
        }];
    }
    
    if ([eventName isEqualToString:UN_ARGUMENT_EVENT_NAME]) {
        LRSpeakerCellModel *model = userInfo.allValues.firstObject;
        __block NSString *username = model.username;
        [LRSpeakHelper.sharedInstance unArgumentMic:self.roomModel.roomId
                                       completion:^(NSString * _Nonnull errorInfo, BOOL success)
         {
             if (success) {
                 [LRSpeakHelper.sharedInstance setupSpeakerMicOff:username];
             }
         }];
    }
    
    if ([eventName isEqualToString:DISCONNECT_EVENT_NAME]) {
        LRSpeakerCellModel *model = userInfo.allValues.firstObject;
        NSString *username = model.username;
        if ([username isEqualToString:kCurrentUsername]) {
            [LRSpeakHelper.sharedInstance requestOffSpeaker:self.roomModel
                                                 completion:nil];
        } else {
            [LRSpeakHelper.sharedInstance setupUserToAudiance:username];
        }
    }
}

#pragma mark - LRSpeakHelperDelegate

// 收到有人上麦回调
- (void)receiveSomeoneOnSpeaker:(NSString *)aUsername
                       streamId:(nonnull NSString *)aStreamId
                           mute:(BOOL)isMute
{
    if ([self.memberList containsObject:aUsername]) {
        return;
    }
    [self.memberList addObject:aUsername];
    BOOL isAdmin = [self.roomModel.owner isEqualToString:aUsername];
    [self addMemberToDataAry:aUsername streamId:aStreamId mute:isMute admin:isAdmin];
}

// 收到有人下麦回调
- (void)receiveSomeoneOffSpeaker:(NSString *)aUsername {
    if (![self.memberList containsObject:aUsername]) {
        return;
    }
    [self.memberList removeObject:aUsername];
    [self removeMemberFromDataAry:aUsername] ;
}

// 收到成员静音状态变化
- (void)receiveSpeakerMute:(NSString *)aUsername
                      mute:(BOOL)isMute {
    for (LRSpeakerCellModel *model in self.dataAry) {
        if ([model.username isEqualToString:aUsername]) {
            model.speakOn = !isMute;
            break;
        }
    }
    [self.tableView reloadData];
}

// 房间属性变化
- (void)roomTypeDidChange:(LRRoomType)aType {
    self.roomModel.roomType = aType;
    [self.headerView setType:aType];
    if (aType == LRRoomType_Host && [self.roomModel.owner isEqualToString:kCurrentUsername]) {
        // 如果是主持模式，且当前账号是管理员，直接上麦
        [LRSpeakHelper.sharedInstance setupSpeakerMicOn:kCurrentUsername];
    }
}

// 谁在说话回调 (在主持模式下，标注谁在说话)
- (void)currentHostTypeSpeakerChanged:(NSString *)aSpeaker {
    // 首先更新自己发布声音的情况
    if ([aSpeaker isEqualToString:kCurrentUsername]) {
        [LRSpeakHelper.sharedInstance muteMyself:NO];
    }else {
        [LRSpeakHelper.sharedInstance muteMyself:YES];
    }
    
    for (LRSpeakerCellModel *model in self.dataAry) {
        if ([aSpeaker isEqualToString:model.username]) {
            model.talkOn = YES;
        }else {
            model.talkOn = NO;
        }
    }
    
    [self.tableView reloadData];
}

// 谁在说话回调 (在抢麦模式下，标注谁在说话)
- (void)currentMonopolyTypeSpeakerChanged:(NSString *)aSpeaker {
    
    BOOL isMySelf = [aSpeaker isEqualToString:kCurrentUsername];
    if (!isMySelf) {
        [LRSpeakHelper.sharedInstance muteMyself:YES];
    }else {
        [LRChatHelper.sharedInstance sendMessageFromNoti:@"抢麦成功"];
        [LRSpeakHelper.sharedInstance muteMyself:NO];
    }
    
    LRSpeakerCellModel *myModel = nil;
    for (LRSpeakerCellModel *model in self.dataAry) {
        if (model.isMyself) {
            myModel = model;
            break;
        }
    }
    if (!myModel) {
        return;
    }
    
    if (isMySelf) {
        myModel.argumentOn = NO;
        myModel.unArgumentOn = YES;
    }else {
        myModel.argumentOn = [aSpeaker isEqualToString:@""] ? YES : NO;
        myModel.unArgumentOn = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (LRSpeakerTypeView *)headerView {
    if (!_headerView) {
        _headerView = [[LRSpeakerTypeView alloc] init];
        [_headerView setupEnable:NO];
    }
    return _headerView;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (NSMutableArray *)memberList {
    if (!_memberList) {
        _memberList = [NSMutableArray array];
    }
    return _memberList;
}

@end
