//
//  LRRoomListViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRRoomListViewController.h"
#import "LRVoiceChatRoomListCell.h"
#import "LRRealtimeSearch.h"
#import "LRSearchBar.h"
#import "LRVoiceChatRoomListCell.h"
#import "LRRoomModel.h"
#import "LRRoomViewController.h"
#import "Headers.h"
#import "LRFindView.h"
#import "LRRequestManager.h"

#define kPadding 16
@interface LRRoomListViewController () <LRSearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, strong) LRSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UITableView *searchResultTableView;

@end

@implementation LRRoomListViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self autoReload];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(autoReload)
                                               name:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED
                                             object:nil];
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"选择房间 Chose a voiceChatroom";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPadding);
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
    }];
    
    [self _setupSearch];
    [self _setupRefresh];
}

- (void)_setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadPage)];
}

- (void)_setupSearch
{
    self.searchBar = [[LRSearchBar alloc] init];
    self.searchBar.placeholderString = @"输入voiceChatroomID";
    self.searchBar.placeholderTextFont = 17;
    self.searchBar.placeholderTextColor = RGBACOLOR(255, 255, 255, 0.6);
    self.searchBar.height = 48;
    LRFindView *findView = [[LRFindView alloc] init];
    self.searchBar.leftView = findView;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tag = 10;
    self.tableView.rowHeight = 48;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding - 1);
        make.right.equalTo(self.view).offset(-kPadding + 1);
        make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight - 49);
    }];
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewAction:)];
    tapTableView.delegate = self;
    [self.tableView addGestureRecognizer:tapTableView];
    
    self.searchResultTableView = [[UITableView alloc] init];
    self.searchResultTableView.tag = 11;
    self.searchResultTableView.backgroundColor = [UIColor blackColor];
    self.searchResultTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.searchResultTableView.rowHeight = self.tableView.rowHeight;
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    UITapGestureRecognizer *tapSRTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSRTableViewAction:)];
    tapSRTableView.delegate = self;
    [self.searchResultTableView addGestureRecognizer:tapSRTableView];
}

#pragma mark - GestureRecognizer
-(void)tapTableViewAction:(UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

-(void)tapSRTableViewAction:(UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
        }
    return YES;
}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    LRRoomModel *model = nil;
    if (tableView == self.tableView) {
        model = [self.dataArray objectAtIndex:indexPath.row];
    } else {
        model = [self.searchResults objectAtIndex:indexPath.row];
    }
    cell.model = model;
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LRRoomModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [self joinRoomWithModel:model];
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
                    make.top.equalTo(self.searchBar.mas_bottom).offset(12);
                    make.left.equalTo(self.view).offset(kPadding - 1);
                    make.right.equalTo(self.view).offset(-kPadding + 1);
                    make.bottom.equalTo(self.view).offset(-LRSafeAreaBottomHeight - 49);
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
    [[LRRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(roomname) resultBlock:^(NSArray *results) {
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

#pragma mark - Actions
- (void)joinRoomWithModel:(LRRoomModel *)aModel {

    NSString *info = [NSString stringWithFormat:@"房主: %@\n聊天室ID: %@\n语音会议ID: %@\n房间最大人数: %d\n创建时间: %@\n允许观众上麦: %@", aModel.owner, aModel.roomId, aModel.conferenceId, aModel.maxCount, aModel.createTime, aModel.allowAudienceOnSpeaker ? @"True":@"False"];
    LRAlertController *alert = [LRAlertController showSuccessAlertWithTitle:aModel.roomname info:info];
    alert.textField = [[UITextField alloc] init];
    LRAlertAction *joinAction = [LRAlertAction alertActionTitle:@"加入" callback:^(LRAlertController * _Nonnull alertController) {
        if (alertController.textField.text.length == 0) {
            return;
        }
        LRRoomViewController *vroomVC = [[LRRoomViewController alloc] initWithUserType:LRUserType_Audiance roomModel:aModel password:alertController.textField.text];
        [self presentViewController:vroomVC animated:YES completion:nil];
    }];
    
    LRAlertAction *cancelAction = [LRAlertAction alertActionTitle:@"取消" callback:nil];
    [alert addAction:joinAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)autoReload {
    [self.tableView.mj_header beginRefreshing];
    [self reloadPage];
}

- (void)reloadPage {
    
    [LRRequestManager.sharedInstance requestWithMethod:@"GET" urlString:@"http://turn2.easemob.com:8082/app/talk/rooms/0/200" parameters:nil token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!error) {
                 NSArray *list = result[@"list"];
                 [self.dataArray removeAllObjects];
                 if (list) {
                     for (NSDictionary *dic in list) {
                         LRRoomModel *model = [LRRoomModel roomWithDict:dic];
                         [self.dataArray addObject:model];
                     }
                 }
             }else {
                 // TODO: error alert
             }
             [self endReload];
         });
    }];
}

- (void)endReload {
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

@end
