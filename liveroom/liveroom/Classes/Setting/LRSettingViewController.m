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
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight);
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
        return 50;
    }
    return 70;
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
            switchControl = [[LRSettingSwitch alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 70, 10, 50, 30)];
            switchControl.tag = section * 10 + row;
            switchControl.delegate = self;
            [cell.contentView addSubview:switchControl];
        }
    } else if (isSwitchCell) {
        switchControl = [cell.contentView viewWithTag:(section * 10 + row)];
    }
    
    cell.detailTextLabel.text = nil;
    if (section == 0) {
        [self displayWithCell:cell title:@"版本version" details:nil detailText:@"1.01" accessoryType:UITableViewCellAccessoryNone switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 1) {
        [self displayWithCell:cell title:@"speakerNumberLimited default" details:@"默认创建voicechatroom互动主播数" detailText:@"6" accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 2) {
        [self displayWithCell:cell title:@"Allow apply for interact default" details:@"允许观众申请连麦" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:YES isAnimated:YES];
    } else if (section == 3) {
        [self displayWithCell:cell title:@"type of voiceChatroom" details:@"主持,抢麦,互动三种模式的默认参数" detailText:@"host" accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 4) {
        [self displayWithCell:cell title:@"audio quality default" details:@"默认音质参数" detailText:@"highleve(unmix)" accessoryType:UITableViewCellAccessoryDisclosureIndicator switchControl:nil isSwitch:NO isAnimated:NO];
    } else if (section == 5) {
        [self displayWithCell:cell title:@"audio agree to apply as speaker" details:@"自动允许上麦申请" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:YES isAnimated:YES];
    } else if (section == 6) {
        [self displayWithCell:cell title:@"Automatically turn on music" details:@"创建直播间默认开启背景音乐" detailText:nil accessoryType:UITableViewCellAccessoryNone switchControl:switchControl isSwitch:YES isAnimated:YES];
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
        return 0;
    }
    if (section == 5) {
        return 20;
    }
    return 3;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark LRSettingSwitchDelegate
- (void)settingSwitchWithValueChanged:(LRSettingSwitch *)aSwitch
{
    NSLog(@"isOn------%d", aSwitch.isOn);
    
}

@end
