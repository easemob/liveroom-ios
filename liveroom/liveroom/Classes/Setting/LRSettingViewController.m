//
//  LRSettingViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSettingViewController.h"
#import "LRSettingTableViewCell.h"
#import "LRSettingSwitch.h"
#import "LRRoomOptions.h"


#define kPadding 16
@interface LRSettingViewController () <UITableViewDelegate, UITableViewDataSource, LRSettingSwitchDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation LRSettingViewController

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logoutAction)
                                                   name:LR_Did_Login_Other_Device_Notification
                                                 object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self _setupSubviews];
    
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"设置 settingProfile";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPadding);
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor blackColor]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight - 49);
    }];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    self.footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.footerView;
    
    UIButton *logoutButton = [[UIButton alloc] init];
    [logoutButton setBackgroundColor:[UIColor whiteColor]];
    [logoutButton setTitle:[NSString stringWithFormat:@"退出 (%@)", [EMClient sharedClient].currentUsername] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(20);
        make.left.equalTo(self.footerView);
        make.right.equalTo(self.footerView);
        make.height.equalTo(@50);
    }];
}

- (void)logoutAction
{
    [[EMClient sharedClient] logout:NO completion:^(EMError *aError) {
        if (!aError) {
            EMOptions *options = [LRChatHelper sharedInstance].registerImSDK;
            options.isAutoLogin = NO;
            [[LRRoomOptions sharedOptions] archive];
            [[NSNotificationCenter defaultCenter] postNotificationName:LR_ACCOUNT_LOGIN_CHANGED
                                                                object:@NO];
        } else {
            LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:@"退出登录失败" info:aError.errorDescription];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - TablevViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"UITableViewCell";
    if (section == 2 || section == 4 || section == 5) {
        cellIdentifier = @"UITableViewCellSwitch";
    }
    LRSettingSwitch *switchControl = nil;
    BOOL isSwitchCell = NO;
    if (section == 2 || section == 4 || section == 5) {
        isSwitchCell = YES;
    }
    LRSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LRSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (isSwitchCell) {
            switchControl = [[LRSettingSwitch alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 38 - 16, 10, 38, 24)];
            switchControl.tag = section * 10 + row;
            switchControl.delegate = self;
            [cell.contentView addSubview:switchControl];
        }
    } else if (isSwitchCell) {
        switchControl = [cell.contentView viewWithTag:(section * 10 + row)];
    }
    
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    
    if (section == 0) {
        [self displayWithCell:cell title:@"版本version" details:nil detailText:options.version accessoryType:UITableViewCellAccessoryNone switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 1) {
        [self displayWithCell:cell title:@"speakerNumberLimited default" details:@"默认创建voicechatroom互动主播数" detailText:[NSString stringWithFormat:@"%d", options.speakerNumber] accessoryType:UITableViewCellAccessoryNone switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 2) {
        [self displayWithCell:cell title:@"Allow apply for interact default" details:@"允许观众申请连麦" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:options.isAllowAudienceApplyInteract isAnimated:YES];
    } else if (section == 3) {
        [self displayWithCell:cell title:@"audio quality default" details:@"默认音质参数" detailText:@"highleve(unmix)" accessoryType:UITableViewCellAccessoryNone switchControl:nil isSwitch:NO isAnimated:YES];
    } else if (section == 4) {
        [self displayWithCell:cell title:@"audio agree to apply as speaker" details:@"自动允许上麦申请" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:options.isAllowApplyAsSpeaker isAnimated:YES];
    } else if (section == 5) {
        [self displayWithCell:cell title:@"Automatically turn on music" details:@"创建直播间默认开启背景音乐" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:options.isAutomaticallyTurnOnMusic isAnimated:YES];
    }
    
    return cell;
}

- (void)displayWithCell:(LRSettingTableViewCell *)cell title:(NSString *)title details:(NSString *)details detailText:(NSString *)detailText accessoryType:(UITableViewCellAccessoryType)accessoryType switchControl:(LRSettingSwitch *)switchControl isSwitch:(BOOL)isSwitch isAnimated:(BOOL)isAnimated
{
    if (title) {
        cell.title = title;
    }
    if (details) {
        cell.details = details;
    }
    if (detailText) {
        cell.detailsText = detailText;
    }
    if (accessoryType) {
        cell.accessoryType = accessoryType;
    }
    if (switchControl) {
        [switchControl setOn:isSwitch animated:isAnimated];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 12;
    }
    if (section == 4) {
        return 24;
    }
    return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark LRSettingSwitchDelegate
- (void)settingSwitchWithValueChanged:(LRSettingSwitch *)aSwitch
{
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    NSInteger tag = aSwitch.tag;
    switch (tag) {
        case 20:
        {
            options.isAllowAudienceApplyInteract = aSwitch.isOn;
            [options archive];
        }
            break;
        case 40:
        {
            options.isAllowApplyAsSpeaker = aSwitch.isOn;
            [options archive];
        }
            break;
        case 50:
        {
            options.isAutomaticallyTurnOnMusic = aSwitch.isOn;
            [options archive];
        }
            break;
        default:
            break;
    }
    
}

@end
