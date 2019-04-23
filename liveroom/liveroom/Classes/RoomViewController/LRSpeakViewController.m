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
#import "LRSpeakerTypeView.h"
#import "LRSpeakHelper.h"
#import "LRRoomModel.h"
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
@property (nonatomic, strong) NSMutableArray *memberList;
@end

@implementation LRSpeakViewController

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
    [self.headerView setType:LRRoomType_Communication];
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
    LRSpeakerCellModel *model = self.dataAry[indexPath.row];
    LRSpeakerCell *cell;
    if (model.username) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerOnCell"];
        if (!cell) {
            cell = [[LRSpeakerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerOnCell"];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerOffCell"];
        if (!cell) {
            cell = [[LRSpeakerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerOffCell"];
        }
    }
    cell.model = model;
    [cell updateSubViewUI];
    return cell;
}

#pragma mark - Actions
// 添加speaker
- (void)addMemberToDataAry:(NSString *)aMember
                  streamId:(NSString *)aStreamId
                      mute:(BOOL)isMute
                     admin:(BOOL)isAdmin{
    
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
        nModel.argumentOn = NO;
        nModel.unArgumentOn = NO;
    }
    if (isAdmin) {
        [self.dataAry replaceObjectAtIndex:0 withObject:nModel];
    }
    
    [self.tableView reloadData];
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
            dModel.username = @"";
            dModel.streamId = @"";
            dModel.type = self.roomModel.roomType;
            dModel.isAdmin = NO;
            dModel.isMyself = NO;
            dModel.isOwner = NO;
            dModel.speakOn = NO;
            dModel.argumentOn = NO;
            dModel.unArgumentOn = NO;
            
            [self.dataAry replaceObjectAtIndex:5 withObject:dModel];
        }
    [self.tableView reloadData];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:ON_MIC_EVENT_NAME]) {
        [LRSpeakHelper.sharedInstance muteMyself:NO];
    }
    
    if ([eventName isEqualToString:OFF_MIC_EVENT_NAME]) {
        [LRSpeakHelper.sharedInstance muteMyself:YES];
    }
    
    if ([eventName isEqualToString:TALK_EVENT_NAME]) {
        
    }
    
    if ([eventName isEqualToString:ARGUMENT_EVENT_NAME]) {
        
    }
    
    if ([eventName isEqualToString:UN_ARGUMENT_EVENT_NAME]) {
        
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
}

// 谁在说话回调 (在主持或者抢麦模式下，标注谁在说话)
- (void)currentSpeaker:(NSString *)aSpeaker {
    
}

// TODO: 设置会议属性，会议属性变化

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
