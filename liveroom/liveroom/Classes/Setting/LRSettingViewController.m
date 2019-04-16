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

@end

@implementation LRSettingViewController

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
    
}

#pragma mark - TablevViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
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
    if (section == 2 || section == 5 || section == 6) {
        cellIdentifier = @"UITableViewCellSwitch";
    }
    LRSettingSwitch *switchControl = nil;
    BOOL isSwitchCell = NO;
    if (section == 2 || section == 5 || section == 6) {
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
    
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        [self displayWithCell:cell title:@"版本version" details:nil detailText:options.version accessoryType:UITableViewCellAccessoryNone switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 1) {
        [self displayWithCell:cell title:@"speakerNumberLimited default" details:@"默认创建voicechatroom互动主播数" detailText:[NSString stringWithFormat:@"%d", options.speakerNumber] accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 2) {
        [self displayWithCell:cell title:@"Allow apply for interact default" details:@"允许观众申请连麦" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:options.isAllowAudienceApplyInteract isAnimated:YES];
    } else if (section == 3) {
        NSString *speakerTypeString = nil;
        if (options.speakerType == 1) {
            speakerTypeString = @"host";
        } else if (options.speakerType == 2) {
            speakerTypeString = @"monopoly";
        } else {
            speakerTypeString = @"communication";
        }
        [self displayWithCell:cell title:@"type of voiceChatroom" details:@"主持,抢麦,互动三种模式的默认参数" detailText:speakerTypeString accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:YES];
    } else if (section == 4) {
        [self displayWithCell:cell title:@"audio quality default" details:@"默认音质参数" detailText:@"highleve(unmix)" accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:YES];
    } else if (section == 5) {
        [self displayWithCell:cell title:@"audio agree to apply as speaker" details:@"自动允许上麦申请" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:options.isAllowApplyAsSpeaker isAnimated:YES];
    } else if (section == 6) {
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
        cell.detailTextLabel.text = detailText;
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
    if (section == 5) {
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
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    if (indexPath.section == 3) {
        LRSettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"提示 tip" info:@"切换房间互动模式会初始化麦序。主播模式为当前只有管理员能发言；抢麦模式为当前只有管理员可以发言；互动模式为全部主播均可发言。请确认切换的模式。"];
            LRAlertAction *hostAction = [LRAlertAction alertActionTitle:@"主持模式 Host"
                                                               callback:^(LRAlertController * _Nonnull alertController)
                                         {
                                             options.speakerType = 1;
                                             [options archive];
                                             cell.detailTextLabel.text = @"host";
                                         }];
            
            LRAlertAction *monopolyAction = [LRAlertAction alertActionTitle:@"抢麦模式 monopoly"
                                                                   callback:^(LRAlertController * _Nonnull alertController)
                                             {
                                                 options.speakerType = 2;
                                                 [options archive];
                                                 cell.detailTextLabel.text = @"monopoly";
                                             }];
            
            LRAlertAction *communicationAction = [LRAlertAction alertActionTitle:@"自由麦模式 communication"
                                                                        callback:^(LRAlertController * _Nonnull alertController)
                                                  {
                                                      options.speakerType = 3;
                                                      [options archive];
                                                      cell.detailTextLabel.text = @"communication";
                                                  }];
            
            [alert addAction:hostAction];
            [alert addAction:monopolyAction];
            [alert addAction:communicationAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        });
    }
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
        case 50:
        {
            options.isAllowApplyAsSpeaker = aSwitch.isOn;
            [options archive];
        }
            break;
        case 60:
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
