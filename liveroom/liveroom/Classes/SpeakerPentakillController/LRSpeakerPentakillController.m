//
//  LRSpeakerWerewolfkilledController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/22.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerPentakillController.h"
#import "LRSpeakerPentakillCell.h"
#import "UIResponder+LRRouter.h"
#import "LRCutClockView.h"

@interface LRSpeakerPentakillController ()

@property (nonatomic, strong) UIImageView *moonView;
@property (nonatomic, strong) UIImageView *sunView;

@property (nonatomic, strong) UIButton *sunBtn;
@property (nonatomic, strong) UIButton *moonBtn;

@property (nonatomic) LRTerminator clockstatus;

@property (nonatomic, strong) UIView *werewolfView;

@property (nonatomic, strong) NSMutableDictionary *dic;//静音狼人数组

@property (nonatomic, strong) LRSpeakerPentakillCell *cell;

@end

@implementation LRSpeakerPentakillController
Boolean isExcute;  //每次加入房间回调只执行一次
- (void)viewDidLoad {
    isExcute = false;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //时钟状态改变发言状态置为关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(voiceActionClose)
                                                 name:LR_CLOCK_STATE_CHANGE
                                               object:nil];
    //首次设置时钟状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(callBackClockStatus:)
                                                 name:LR_CLOCK_STATE_CHANGE
                                               object:nil];
    
    
    if(![self.roomModel.owner isEqualToString:kCurrentUsername]){
        //夜晚狼人下麦操作
        [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(setCoverUI)
                                             name:LR_Receive_ToBe_Audience_Notification
                                                   object:nil];
    }

    [self _setupSubViews];
}
//切换状态之后全部主播静音，不可说话
- (void)voiceActionClose{
    for (LRSpeakerCellModel *model in self.dataAry) {
        [self routerEventWithName:@"pkOffMicEventName" userInfo:@{@"key" : model}];
    }
    
}

- (void)_setupSubViews {
    //[super setupSubViews];
    [self.view addSubview:self.werewolfView];
    [self.view addSubview:self.schedule];
    
    [_schedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.equalTo(self.headerView.mas_left);
        make.height.equalTo(@35);
        make.right.equalTo(self.headerView.mas_right);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.schedule.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //狼人正在发言遮掩UI
    [self.werewolfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.schedule.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self addNightCoverView];//添加内容给狼人正在发言状态Ui   执行多次需要重新触发定时器
    
    [_schedule addSubview:_sunBtn];
    [_schedule addSubview:_moonBtn];
    [_sunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.schedule.mas_left);
        make.top.equalTo(self.schedule.mas_top);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    [_moonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sunBtn.mas_right).offset(10);
        make.top.equalTo(self.schedule.mas_top);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    if([self.roomModel.owner isEqualToString:kCurrentUsername]){
        self.sunBtn.tag = LRTerminator_dayTime;
        [self.sunBtn addTarget:self action:@selector(adminSwitchClock:) forControlEvents:UIControlEventTouchUpInside];
        self.moonBtn.tag = LRTerminator_night;
        [self.moonBtn addTarget:self action:@selector(adminSwitchClock:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_sunBtn addSubview:_sunView];
    [_moonBtn addSubview:_moonView];
    [_sunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sunBtn.mas_left);
        make.top.equalTo(self.sunBtn.mas_top);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    [_moonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moonBtn.mas_left);
        make.top.equalTo(self.moonBtn.mas_top);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    
}
//时钟状态改变回调
- (void)callBackClockStatus:(NSNotification *)noti{
    NSString *clock = [noti object];
    if([clock isEqualToString:@"LRTerminator_night"]) {
        [self setupClockPic:LRTerminator_night];
    }else {
        [self setupClockPic:LRTerminator_dayTime];
    }
    [self.cell updateIdentity:self.clockstatus];//重置cell的身份
    
    if(!isExcute){
        //注册狼人杀房间通知在房间模式设定之后，防止第一次进入房间弹窗
        if(![self.roomModel.owner isEqualToString:kCurrentUsername]){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reveiceNotification:)
                                                         name:LR_CLOCK_STATE_CHANGE
                                                       object:nil];
        }
        isExcute = true;
    }
}

#pragma mark - getter
//昼夜图片的view
- (UIView *)schedule{
    if(!_schedule){
        _schedule = [[UIView alloc]init];
        _schedule.backgroundColor = [UIColor blackColor];
        _sunView = [[UIImageView alloc]init];
        _moonView = [[UIImageView alloc]init];
        _sunBtn = [[UIButton alloc]init];
        _moonBtn = [[UIButton alloc]init];
    }
    return _schedule;
}

//房间创建者修改当前房间昼夜时钟状态
- (void)adminSwitchClock:(UIButton*)btn{
    long tag = btn.tag;
    if((tag == 1 && self.clockstatus == LRTerminator_dayTime) ||
       (tag == 2 && self.clockstatus == LRTerminator_night)) {
        return;
    }
    LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"提示" info:@"您将要进行白天黑夜模式的切换，\n操作后所有人的发言状态将被初始化。\n确认操作么？"];
    LRAlertAction *confirm = [LRAlertAction alertActionTitle:@"确认" callback:^(LRAlertController *_Nonnull          alertContoller){
        if(tag == 1 && self.clockstatus == LRTerminator_night){
            [self setupClockPic:LRTerminator_dayTime];
        }else if(tag == 2 && self.clockstatus == LRTerminator_dayTime){
            [self setupClockPic:LRTerminator_night];
            if(self.clockstatus == LRTerminator_night &&
               [self.roomModel.identity isEqualToString:@"villager"]){
                [self muteWereWolf];//村民静音狼人
            }else{
                [self reMuteWereWolf];//重新监听狼人说话
            }
        }
        
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

//接受房主改变房间时钟状态的通知
- (void)reveiceNotification:(NSNotification *)noti{
    NSString *clock = [noti object];
    if([clock isEqualToString:@"LRTerminator_night"]) {
        [self setupClockPic:LRTerminator_night];
    }else {
        [self setupClockPic:LRTerminator_dayTime];
    }
    if(self.clockstatus == LRTerminator_night &&
       [self.roomModel.identity isEqualToString:@"villager"]){
        [self muteWereWolf];// 夜晚村民静音狼人
    }else{
        [self reMuteWereWolf];//白天村民重新监听狼人说话
    }
}

//设置当前时钟昼夜图片
- (void)setupClockPic:(LRTerminator)clock{
    UIImage *ImageSun;
    UIImage *ImageMoon;
    if(clock == LRTerminator_dayTime){
        ImageSun = [UIImage imageNamed:@"sun"];
        ImageMoon = [UIImage imageNamed:@"emptymoon"];
    }else if(clock == LRTerminator_night){
        ImageSun = [UIImage imageNamed:@"emptysun"];
        ImageMoon = [UIImage imageNamed:@"moon"];
    }
    _sunView.image = ImageSun;
    _moonView.image = ImageMoon;
    if(![self.roomModel.owner isEqualToString:kCurrentUsername]){
        if(clock == LRTerminator_dayTime){
            self.moonBtn.hidden = YES;
            self.sunBtn.hidden = NO;
        }else{
            self.moonBtn.hidden = NO;
            self.sunBtn.hidden = YES;
            [_moonBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.schedule.mas_left);
                make.top.equalTo(self.schedule.mas_top);
                make.height.equalTo(@35);
                make.width.equalTo(@35);
            }];
        }
    }
    [self setCurrentClock:clock];
}

//改变当前时钟状态
- (void)setCurrentClock:(LRTerminator)newClock{
    self.clockstatus = newClock;
    self.roomModel.clockStatus = newClock;
    //主播身份是村民并且时钟是夜晚，主播列表遮掩UI
    if(![self.roomModel.identity isEqualToString:@"pentakill"] && _clockstatus == LRTerminator_night){
        self.tableView.hidden = YES;
        [_coverView startTimers];
        self.werewolfView.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        [_coverView stopTimers];//先停止计时器
        self.werewolfView.hidden = YES;
    }
    //是房间管理员才可以修改server的时钟状态
    if(self.roomModel.owner == kCurrentUsername){
        NSString *clock;
        if(_clockstatus == LRTerminator_dayTime){
            clock = @"LRTerminator_dayTime";
        }else if(_clockstatus == LRTerminator_night){
            clock = @"LRTerminator_night";
        }
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:@"clockStatus" value:clock completion:^(EMError *aError)
         {}];
    }
}

//夜晚狼人下麦操作
- (void)setCoverUI {
    if(self.roomModel.clockStatus == LRTerminator_night){
        //如果是狼人夜晚下麦则需要遮掩UI
        if([self.roomModel.identity isEqualToString:@"pentakill"]){
            self.tableView.hidden = YES;
            self.werewolfView.hidden = NO;
            [self.coverView startTimers];
        }
        //如果是村民需要重新监听狼人讲话
        if([self.roomModel.identity isEqualToString:@"villager"]){
            [self reMuteWereWolf];//夜晚被下麦村民身份置为观众（空字符串） 重新监听狼人发言
        }
    }
    self.roomModel.identity = @""; //重置该下麦主播狼人杀身份为观众（即空字符串）
}

//夜晚村民mute remote（静音）狼人
- (void)muteWereWolf {
    int i = -1;
    for (LRSpeakerCellModel *model in self.dataAry) {
        i += 1;
        NSLog(@"\ncurrentmodelusername--------->:   name:   %@,  stream:    %@",model.username,model.streamId);
        for (NSString *werewolf in LRSpeakHelper.sharedInstance.identityDic) {
            NSLog(@"\ncurrentwerewolf--------->:   %@",werewolf);
            if ([model.username isEqualToString:werewolf]) {
                [EMClient.sharedClient.conferenceManager muteRemoteAudio:model.streamId mute:YES];
                [self.dic setObject:[NSString stringWithFormat:@"%d",i] forKey:werewolf];
                break;
            }
        }
        if(self.dic.count == LRSpeakHelper.sharedInstance.identityDic.count){
            break;
        }
    }
    NSLog(@"\ndic.count-------->:  %lu",(unsigned long)self.dic.count);
}
//白天村民重新监听狼人发言
- (void)reMuteWereWolf {
    NSLog(@"\nredic.count-------->:  %lu",(unsigned long)self.dic.count);
    if(self.dic.count != 0){
        for (NSString *werewolf in _dic) {
            LRSpeakerCellModel *model = self.dataAry[[_dic[werewolf] intValue]];
            NSLog(@"\nreleasemode--------->:   name:   %@,  streamid:    %@",model.username,model.streamId);
            [EMClient.sharedClient.conferenceManager muteRemoteAudio:model.streamId mute:NO];
        }
        [self.dic removeAllObjects];
    }
}

- (UIView *)werewolfView {
    if(!_werewolfView) {
        _werewolfView = [[UIView alloc]initWithFrame:CGRectZero];
        _werewolfView.backgroundColor = RGBACOLOR(26,26,26,1);
    }
    return _werewolfView;
}
//夜晚村民遮掩UI
- (void)addNightCoverView {
    self.coverView = [[LRCoverView alloc]init];
    [self.coverView setupNightCoverUI:self.werewolfView];
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
        _cell = (LRSpeakerPentakillCell *)cell;
        [_cell setModel:model];
        [_cell updateSubViewUI];
        [_cell updateIdentity:self.roomModel.clockStatus];//重置cell的身份
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LRSpeakerEmptyCell"];
        if (!cell) {
            cell = [[LRSpeakerEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRSpeakerEmptyCell"];
        }
    }
    return cell;
}

- (NSMutableDictionary *)dic {
    if(!_dic){
        _dic = [[NSMutableDictionary alloc]init];
    }
    return _dic;
}
@end
