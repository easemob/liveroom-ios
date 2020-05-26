//
//  LRSpeakerCommunicationViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/21.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerCommunicationViewController.h"
#import "LRSpeakerCommunicationCell.h"

@interface LRSpeakerCommunicationViewController ()

@end

@implementation LRSpeakerCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - table view delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    LRSpeakerCellModel *model = self.dataAry[indexPath.row];
    if (model.username && model.username.length > 0) {
        static NSString *CommunicationCellId = @"Communication";
        cell = [tableView dequeueReusableCellWithIdentifier:CommunicationCellId];
        if (!cell) {
            cell = [[LRSpeakerCommunicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommunicationCellId];
        }
        [(LRSpeakerCommunicationCell *)cell setModel:model];
        [(LRSpeakerCommunicationCell *)cell updateSubViewUI];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerEmptyCell"];
        if (!cell) {
            cell = [[LRSpeakerEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerEmptyCell"];
        }
    }
    return cell;
}

@end
