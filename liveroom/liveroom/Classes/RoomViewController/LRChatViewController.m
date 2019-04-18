//
//  LRChatViewController.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/6.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRChatViewController.h"
#import "LRChatHelper.h"
#import "LRRoomModel.h"
#import "Headers.h"

@interface LRChatViewController ()<UITableViewDelegate, UITableViewDataSource, LRChatHelperDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataAry;

@end

@implementation LRChatViewController

- (instancetype)init {
    if (self = [super init]) {
        [LRChatHelper.sharedInstance addDeelgate:self delegateQueue:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self _setupSubViews];
}

#pragma mark - LRChatHelperDelegate
- (void)didReceiveRoomMessageWithRoomId:(NSString *)aChatroomId
                                message:(NSString *)aMessage
                               fromUser:(NSString *)fromUser
                              timestamp:(long long)aTimestamp {
    if ([aChatroomId isEqualToString:_roomModel.roomId]) {
        [self addMessageToData:aMessage fromUser:fromUser timestamp:aTimestamp];
    }
}

#pragma mark - public
- (void)sendText:(NSString *)aText {
    if (!aText || aText.length == 0) {
        return;
    }
    [LRChatHelper.sharedInstance sendMessageToChatroom:self.roomModel.roomId
                                               message:aText
                                            completion:^(NSString * _Nonnull errorInfo, BOOL success)
     {
         // 此处没有处理发送失败的情况，不论发送是否成功，均上屏;
     }];
    
    [self addMessageToData:aText
                  fromUser:LRChatHelper.sharedInstance.currentUser
                 timestamp:[[NSDate new] timeIntervalSince1970]];
}

#pragma mark - private
- (void)addMessageToData:(NSString *)aMessage fromUser:(NSString *)aUsername timestamp:(long long)aTimestamp{
    NSString *str = [self dateFormatter:aTimestamp];
    NSString *from = aUsername;
    str = [NSString stringWithFormat:@"%@ %@ %@",str, from, aMessage];
    NSRange range = [str rangeOfString:from];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    
    [self.dataAry addObject:attStr];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataAry.count-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (NSString *)dateFormatter:(long long)aTimestamp {
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:aTimestamp];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:aDate];
}

#pragma mark - table view delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LRChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LRChatCell"];
    if (!cell) {
        cell = [[LRChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRChatCell"];
    }
    cell.chatInfoLabel.attributedText = self.dataAry[indexPath.row];
    return cell;
}


#pragma mark - subviews;
- (void)_setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = LRColor_HeightBlackColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

@end

@interface LRChatCell ()

@end

@implementation LRChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubView];
    }
    return self;
}

#pragma mark - subviews

- (void)_setupSubView {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.chatInfoLabel];
    [self.chatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - getter
- (UILabel *)chatInfoLabel {
    if (!_chatInfoLabel) {
        _chatInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chatInfoLabel.backgroundColor = [UIColor clearColor];
        _chatInfoLabel.textColor = [UIColor whiteColor];
        _chatInfoLabel.font = [UIFont systemFontOfSize:13];
        _chatInfoLabel.numberOfLines = 0;
        _chatInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _chatInfoLabel;
}

@end

