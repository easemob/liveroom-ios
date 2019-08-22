//
//  LRSpeakerWerewolfkilledController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/22.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerPentakillController.h"
#import "LRSpeakerPentakillCell.h"

@interface LRSpeakerPentakillController ()

@end

@implementation LRSpeakerPentakillController

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
        static NSString *PentakillCellId = @"Pentakill";
        cell = [tableView dequeueReusableCellWithIdentifier:PentakillCellId];
        if (!cell) {
            cell = [[LRSpeakerPentakillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PentakillCellId];
        }
        [(LRSpeakerPentakillCell *)cell setModel:model];
        [(LRSpeakerPentakillCell *)cell updateSubViewUI];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerEmptyCell"];
        if (!cell) {
            cell = [[LRSpeakerEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerEmptyCell"];
        }
    }
    return cell;
}

@end
