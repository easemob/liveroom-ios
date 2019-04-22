//
//  LRSpeakViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/4.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRSpeakViewController.h"
#import "LRVolumeView.h"
#import "LRSpeakerTypeView.h"
#import "LRSpeakHelper.h"
#import "LRRoomModel.h"
#import "Headers.h"

#define kMaxSpeakerCount 6

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
    cell.isOwner = [self.roomModel.owner isEqualToString:kCurrentUsername];
    [cell updateSubViewUI];
    return cell;
}

#pragma mark - Actions
// 添加speaker
- (void)addMemberToDataAry:(NSString *)aMember
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
        nModel.isMute = isMute;
        nModel.isAdmin = isAdmin;
        nModel.isMyself = [aMember isEqualToString:kCurrentUsername];
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
            dModel.isMute = NO;
            dModel.isAdmin = NO;
            dModel.isMyself = NO;
            // 将空的放到最后一个位置
        }
        [self.dataAry replaceObjectAtIndex:5 withObject:dModel];
    
    [self.tableView reloadData];
}

#pragma mark - LRSpeakHelperDelegate

// 收到有人上麦回调
- (void)receiveSomeoneOnSpeaker:(NSString *)aUsername mute:(BOOL)isMute{
    if ([self.memberList containsObject:aUsername]) {
        return;
    }
    [self.memberList addObject:aUsername];
    BOOL isAdmin = [self.roomModel.owner isEqualToString:aUsername];
    [self addMemberToDataAry:aUsername mute:isMute admin:isAdmin];
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
            model.isMute = isMute;
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

@interface LRSpeakerCell ()
@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *crownImage;
@property (nonatomic, strong) LRVolumeView *volumeView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *voiceEnableBtn;
@property (nonatomic, strong) UIButton *disconnectBtn;

@end

@implementation LRSpeakerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = LRColor_HeightBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self.contentView addSubview:self.lightView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.crownImage];
    [self.contentView addSubview:self.volumeView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.voiceEnableBtn];
    [self.contentView addSubview:self.disconnectBtn];
    
    [self.lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.width.height.equalTo(@8);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.lessThanOrEqualTo(self.volumeView.mas_left).offset(-32);
        make.bottom.equalTo(self.lineView.mas_top).offset(-10).priorityLow();
    }];
    
    [self.crownImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.height.width.equalTo(@25);
    }];
    
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@10);
        make.height.equalTo(@18);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@2);
    }];
    
    [self layoutIfNeeded];
}

- (void) updateSubViewUI {
    BOOL voiceEnableBtnNeedShow = NO;
    BOOL disconnectBtnNeedShow = NO;
    
    // 如果有数据
    if (![_model.username isEqualToString:@""]) {
        self.nameLabel.text = _model.username;
        self.lightView.backgroundColor = !_model.isMute ? [UIColor yellowColor] : LRColor_MiddleBlackColor;
        if (_model.isAdmin) {
            self.crownImage.hidden = NO;
        }else {
            self.crownImage.hidden = YES;
        }
    
        voiceEnableBtnNeedShow = _model.isMyself;
        disconnectBtnNeedShow = _model.isMyself || _isOwner;
    } else {
        self.nameLabel.text = @"已下线";
        self.lightView.backgroundColor = LRColor_LowBlackColor;
        self.crownImage.hidden = YES;
    }
    
    if (voiceEnableBtnNeedShow) {
        self.voiceEnableBtn.hidden = NO;
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.lightView);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
    }else {
        [self.voiceEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        self.voiceEnableBtn.hidden = YES;
    }
    
    if (disconnectBtnNeedShow) {
        self.disconnectBtn.hidden = NO;
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.voiceEnableBtn.mas_right).offset(10);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
    }else {
        [self.disconnectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        self.disconnectBtn.hidden = YES;
    }
}

#pragma mark - actions
- (void)voiceEnableAction:(UIButton *)aBtn {
    aBtn.selected = !aBtn.selected;
    if (aBtn.selected) {
        [_voiceEnableBtn strokeWithColor:LRStrokeGreen];
    }else {
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
    }
}

- (void)disconnectAction:(UIButton *)aBtn {
    aBtn.selected = !aBtn.selected;
}

#pragma mark - getter
- (UIView *)lightView {
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _lightView.layer.masksToBounds = YES;
        _lightView.layer.cornerRadius = 4;
        _lightView.backgroundColor = [UIColor yellowColor];
    }
    return _lightView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    return _nameLabel;
}

- (UIImageView *)crownImage {
    if (!_crownImage) {
        _crownImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _crownImage.image = [UIImage imageNamed:@"crown"];
    }
    return _crownImage;
}

- (LRVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[LRVolumeView alloc] initWithFrame:CGRectZero];
        _volumeView.backgroundColor = [UIColor blackColor];
        _volumeView.progress = 0.5;
    }
    return _volumeView;
}

- (UIButton *)voiceEnableBtn {
    if (!_voiceEnableBtn) {
        _voiceEnableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceEnableBtn strokeWithColor:LRStrokeLowBlack];
        [_voiceEnableBtn setTitle:@"打开麦克风" forState:UIControlStateNormal];
        [_voiceEnableBtn setTitle:@"关闭麦克风" forState:UIControlStateSelected];
        [_voiceEnableBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voiceEnableBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _voiceEnableBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_voiceEnableBtn addTarget:self action:@selector(voiceEnableAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceEnableBtn;
}

- (UIButton *)disconnectBtn {
    if (!_disconnectBtn) {
        _disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disconnectBtn strokeWithColor:LRStrokeRed];
        [_disconnectBtn setTitle:@"下麦" forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_disconnectBtn setTitleColor:LRColor_LowBlackColor forState:UIControlStateSelected];
        _disconnectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_disconnectBtn addTarget:self action:@selector(disconnectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disconnectBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

@end

@implementation LRSpeakerCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.username = @"";
    }
    return self;
}
@end
