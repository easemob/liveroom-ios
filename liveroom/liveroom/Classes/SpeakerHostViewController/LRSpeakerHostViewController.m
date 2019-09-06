//
//  LRSpeakerHostViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/21.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerHostViewController.h"
#import "LRSpeakerHostCell.h"

@interface LRSpeakerHostViewController ()

@end

@implementation LRSpeakerHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - table view delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    LRSpeakerCellModel *model = self.dataAry[indexPath.row];
    if (model.username && model.username.length > 0) {
        static NSString *HostCellId = @"host";
        cell = [tableView dequeueReusableCellWithIdentifier:HostCellId];
        if (!cell) {
            cell = [[LRSpeakerHostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HostCellId];
        }
        [(LRSpeakerHostCell *)cell setModel:model];
        [(LRSpeakerHostCell *)cell updateSubViewUI];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerEmptyCell"];
        if (!cell) {
            cell = [[LRSpeakerEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerEmptyCell"];
        }
    }
    return cell;
}

@end
