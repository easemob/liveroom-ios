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
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation LRChatViewController

- (void)dealloc {
    NSLog(@" ---- lrChVC - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    LRChatHelper.sharedInstance.roomModel = _roomModel;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chatTableviewRoll:)
                                                 name:LR_ChatView_Tableview_Roll_Notification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessageNoti:)
                                                 name:LR_Send_Messages_Notification
                                               object:nil];
}

- (void)chatTableviewRoll:(NSNotification *)aNoti
{
    if (self.dataAry.count > 0) {
        [self.tableView reloadData];
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.dataAry.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - LRChatHelperDelegate
- (void)didReceiveRoomMessageWithRoomId:(NSString *)aChatroomId
                                message:(NSString *)aMessage
                               fromUser:(NSString *)fromUser
                              timestamp:(long long)aTimestamp {
    if ([aChatroomId isEqualToString:_roomModel.roomId])
    {
        [self addMessageToData:aMessage fromUser:fromUser timestamp:aTimestamp / 1000];
    }
    if ([aMessage isEqualToString:kMessageFavourite]) {
        [self animationImageName:@"like"];
    }
    
    if ([aMessage isEqualToString:kMessageGift]) {
        [self animationImageName:@"giftcard"];
    }
}

#pragma mark - notification
- (void)sendMessageNoti:(NSNotification *)aNoti {
    NSString *text = aNoti.object;
    [self sendText:text];
}



#pragma mark - public
- (void)sendText:(NSString *)aText {
    if (!aText || aText.length == 0) {
        return;
    }
    NSLog(@" %@ -- 发送的消息-----%@", self, aText);
    [LRChatHelper.sharedInstance sendMessage:aText
                                  completion:^(NSString * _Nonnull errorInfo, BOOL success)
     {
         // 此处没有处理发送失败的情况，不论发送是否成功，均上屏;
     }];
    
    [self addMessageToData:aText
                  fromUser:LRChatHelper.sharedInstance.currentUser
                 timestamp:[[NSDate new] timeIntervalSince1970]];
}

- (void)sendLike {
    [self audioPlayerWithName:@"like" type:@"wav"];
    [self animationImageName:@"like"];
    [LRChatHelper.sharedInstance sendLikeMessage:kMessageFavourite
                                      completion:^(NSString * _Nonnull errorInfo, BOOL success) {
                                          
                                      }];
    
    [self addMessageToData:kMessageFavourite
                  fromUser:LRChatHelper.sharedInstance.currentUser
                 timestamp:[[NSDate new] timeIntervalSince1970]];
}

- (void)sendGift {
    [self audioPlayerWithName:@"gift" type:@"wav"];
    [self animationImageName:@"giftcard"];
    
    [LRChatHelper.sharedInstance sendGiftMessage:kMessageGift
                                      completion:^(NSString * _Nonnull errorInfo, BOOL success) {
                                          
                                      }];
    
    [self addMessageToData:kMessageGift
                  fromUser:LRChatHelper.sharedInstance.currentUser
                 timestamp:[[NSDate new] timeIntervalSince1970]];
}

- (void)animationImageName:(NSString *)imageName
{
    UIView * view = [self.view.superview viewWithTag:99999];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.tag = 99999;
    imageView.alpha = 0.5;
    [self.view.superview addSubview:imageView];
    
    imageView.frame = CGRectMake(0, 0, 90, 90);
    imageView.center = self.view.superview.center;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.alpha = 1;
        imageView.frame = CGRectInset(imageView.frame, 20, 20);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (imageView) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.alpha = 0.1;
                    imageView.frame = CGRectInset(imageView.frame, 25, 25);
                } completion:^(BOOL finished) {
                    if (imageView) {
                        [imageView removeFromSuperview];
                    }
                }];
            }
        });
    }];
}

- (void)audioPlayerWithName:(NSString *)audioName type:(NSString *)type
{
    NSString *string = [[NSBundle mainBundle] pathForResource:audioName ofType:type];
    NSURL *url = [NSURL fileURLWithPath:string];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.volume = 100;
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
}

#pragma mark - private
- (void)addMessageToData:(NSString *)aMessage fromUser:(NSString *)aUsername timestamp:(long long)aTimestamp{
    NSString *str = [self dateFormatter:aTimestamp];
    NSString *from = aUsername;
    if (!from) {
        return;
    }
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

