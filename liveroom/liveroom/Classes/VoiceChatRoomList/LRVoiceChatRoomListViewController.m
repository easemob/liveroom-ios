//
//  LRVoiceChatRoomListViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRVoiceChatRoomListViewController.h"
#import "LRVoiceChatRoomListCell.h"
#import "LRRealtimeSearch.h"
#import "UIViewController+Search.h"
#import "LRVoiceChatRoomListCell.h"
#import "LRChatRoomListModel.h"
#import "LRJoinVoiceChatRoomView.h"
#import "Headers.h"

@interface LRVoiceChatRoomListViewController () <TCSearchControllerDelegate, LRJoinVoiceChatRoomViewDelegate>

@property (nonatomic, strong) LRJoinVoiceChatRoomView *joinVoiceChatRoomView;

@end

@implementation LRVoiceChatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"聊天室名称1",@"聊天室名称2",@"聊天室名称3",@"聊天室名称4",@"聊天室名称5",@"聊天室名称6",@"聊天室名称7",@"聊天室名称8"];
    for (NSString *name in array) {
        LRChatRoomListModel *model = [LRChatRoomListModel initWithChatRoomName:name];
        [self.dataArray addObject:model];
    }
    
    [self _setupSubviews];
    
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
//    self.showRefreshHeader = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"聊天室";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(LRVIEWTOPMARGIN + 15);
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@60);
    }];
    
    [self enableSearchController];
    [self.searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@35);
    }];
    
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchButton.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset((LRVIEWTOPMARGIN + 15));
        make.right.equalTo(self.view).offset(-(LRVIEWTOPMARGIN + 15));
        make.bottom.equalTo(self.view);
    }];
    
    [self _setupSearchResultController];
    
    self.joinVoiceChatRoomView = [[LRJoinVoiceChatRoomView alloc] initWithFrame:CGRectMake(50, 120, 270, 320)];
    self.joinVoiceChatRoomView.delegate = self;
    
}

- (void)_setupSearchResultController
{
    __weak typeof(self) weakself = self;
    self.resultController.tableView.rowHeight = 60;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *cellIdentifier = @"LRVoiceChatRoomListCell";
        LRVoiceChatRoomListCell *cell = (LRVoiceChatRoomListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[LRVoiceChatRoomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSInteger row = indexPath.row;
        LRChatRoomListModel *model = [weakself.resultController.dataArray objectAtIndex:row];
        cell.model = model;
        return cell;
    }];
    [self.resultController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
        return YES;
    }];
//    [self.resultController setCommitEditingAtIndexPath:^(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath) {
//        if (editingStyle != UITableViewCellEditingStyleDelete) {
//            return ;
//        }
//
//        NSInteger row = indexPath.row;
//        LRChatRoomListModel *model = [weakself.resultController.dataArray objectAtIndex:row];
//        [weakself.resultController.dataArray removeObjectAtIndex:row];
//        [weakself.resultController.tableView reloadData];
//    }];
//    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//        NSInteger row = indexPath.row;
//        LRChatRoomListModel *model = [weakself.resultController.dataArray objectAtIndex:row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:model];
//    }];
}


#pragma mark - TablevViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LRVoiceChatRoomListCell";
    LRVoiceChatRoomListCell *cell = (LRVoiceChatRoomListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LRVoiceChatRoomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    LRChatRoomListModel *model = [self.dataArray objectAtIndex:row];
    cell.model = model;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    LRChatRoomListModel *model = [self.dataArray objectAtIndex:row];
    self.joinVoiceChatRoomView.voiceChatRoomName = model.chatRoomName;
    [self.view addSubview:self.joinVoiceChatRoomView];
    [self.view bringSubviewToFront:self.joinVoiceChatRoomView];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//左划操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //在iOS8.0上，必须加上这个方法才能出发左划操作
//    if (editingStyle == UITableViewCellEditingStyleDelete) {

//    }
//}


#pragma mark - TCSearchControllerDelegate

- (void)searchBarWillBeginEditing:(UISearchBar *)searchBar
{
    self.resultController.searchKeyword = nil;
}

- (void)searchBarCancelButtonAction:(UISearchBar *)searchBar
{
    [[LRRealtimeSearch shared] realtimeSearchStop];
    
    [self.resultController.dataArray removeAllObjects];
    [self.resultController.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchTextDidChangeWithString:(NSString *)aString
{
    self.resultController.searchKeyword = aString;
    
    __weak typeof(self) weakself = self;
    [[LRRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.resultController.dataArray removeAllObjects];
            [weakself.resultController.dataArray addObjectsFromArray:results];
            [weakself.resultController.tableView reloadData];
        });
    }];
}

#pragma mark LRJoinVoiceChatRoomViewDelegate
- (void)closeVoiceChatRoomView:(BOOL)isClose
{
    if (isClose) {
        [self.joinVoiceChatRoomView removeFromSuperview];
    }
}

- (void)joinVoiceChatRoom:(BOOL)isSucess
{
    if (isSucess) {
        [self.joinVoiceChatRoomView removeFromSuperview];
    }
}

@end
