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
#import "LRSearchBar.h"
#import "LRVoiceChatRoomListCell.h"
#import "LRChatRoomListModel.h"
#import "LRVoiceRoomViewController.h"
#import "Headers.h"
#import "LRFindView.h"
#import "LRRequestManager.h"

@interface LRVoiceChatRoomListViewController () <LRSearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, strong) LRSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UITableView *searchResultTableView;

@end

@implementation LRVoiceChatRoomListViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchResults
{
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupSubviews];

    [LRRequestManager.sharedInstance getNetworkRequestWithUrl:@"http://turn2.easemob.com:8082/app/talk/rooms/0/100" token:@"" completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                [self.dataArray addObjectsFromArray:dic[@"list"]];
                [self.tableView reloadData];
            }
        });
        
    }];
    
//    NSArray *array = @[@{@"chatRoomName":@"ASD1",@"userName":@"username"},@{@"chatRoomName":@"ASD2",@"userName":@"username"},@{@"chatRoomName":@"ASD3",@"userName":@"username"},@{@"chatRoomName":@"ASD4",@"userName":@"username"},@{@"chatRoomName":@"ASD5",@"userName":@"username"},@{@"chatRoomName":@"ASD6",@"userName":@"username"},@{@"chatRoomName":@"ASD7",@"userName":@"username"},@{@"chatRoomName":@"ASD8",@"userName":@"username"}];
//    for (NSDictionary *dict in array) {
//        LRChatRoomListModel *model = [LRChatRoomListModel initWithChatRoomDict:dict];
//        [self.dataArray addObject:model];
//    }
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"选择房间 Chose a voiceChatroom";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
    }];
    
    [self _setupSearch];
}

- (void)_setupSearch
{
    self.searchBar = [[LRSearchBar alloc] init];
    self.searchBar.placeholderString = @"输入voiceChatroomID";
    self.searchBar.placeholderTextColor = RGBACOLOR(255, 255, 255, 0.6);
    LRFindView *findView = [[LRFindView alloc] init];
    self.searchBar.leftView = findView;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.height.equalTo(@50);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tag = 10;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight);
    }];
    
    self.searchResultTableView = [[UITableView alloc] init];
    self.searchResultTableView.tag = 11;
    self.searchResultTableView.backgroundColor = [UIColor blackColor];
    self.searchResultTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.searchResultTableView.rowHeight = self.tableView.rowHeight;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
}

#pragma mark - TablevViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.tableView) {
        count = [self.dataArray count];
    } else {
        count = [self.searchResults count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LRVoiceChatRoomListCell";
    LRVoiceChatRoomListCell *cell = (LRVoiceChatRoomListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LRVoiceChatRoomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    LRChatRoomListModel *model = nil;
//    if (tableView == self.tableView) {
//        model = [self.dataArray objectAtIndex:indexPath.row];
//    } else {
//        model = [self.searchResults objectAtIndex:indexPath.row];
//    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LRChatRoomListModel *model = [[LRChatRoomListModel alloc] init];
    model.chatRoomName = dic[@"roomname"];
    model.userName = dic[@"roomId"];
    cell.model = model;
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LRVoiceRoomViewController *vroomVC = [[LRVoiceRoomViewController alloc] initWithUserType:LRUserType_Audiance roomInfo:dic];
    [self presentViewController:vroomVC animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//左划操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在iOS8.0上，必须加上这个方法才能出发左划操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {

    }
}

#pragma mark - LRSearchBarDelegate
- (void)searchBarShouldBeginEditing:(LRSearchBar *)searchBar
{
    // 遍历出来searchResultTableView
    for (UIView *subView in self.view.subviews) {
        if (!([subView isKindOfClass:[UITableView class]] && subView.tag == 11)) {
            if (!self.isSearching) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
                self.isSearching = YES;
                self.tableView.hidden = YES;
                [self.view addSubview:self.searchResultTableView];
                [self.searchResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.searchBar.mas_bottom).offset(10);
                    make.left.equalTo(self.view).offset(13);
                    make.right.equalTo(self.view).offset(-13);
                    make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight);
                }];
            }
        }
    }
}

- (void)searchBarCancelAction:(LRSearchBar *)searchBar
{
    [[LRRealtimeSearch shared] realtimeSearchStop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.isSearching = NO;
    [self.searchResults removeAllObjects];
    [self.searchResultTableView reloadData];
    [self.searchResultTableView removeFromSuperview];
    self.tableView.hidden = NO;
}

- (void)searchTextDidChangeWithString:(NSString *)aString
{
    if (!self.isSearching) {
        return;
    }
    __weak typeof(self) weakself = self;
    [[LRRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(chatRoomName) resultBlock:^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.searchResults removeAllObjects];
            [weakself.searchResults addObjectsFromArray:results];
            [weakself.searchResultTableView reloadData];
        });
    }];
}

#pragma mark - KeyBoard
- (void)keyBoardWillShow:(NSNotification *)note
{
    if (!self.isSearching) {
        return;
    }
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.searchResultTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHeight);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    if (!self.isSearching) {
        return;
    }
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.searchResultTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

@end
