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
@interface LRSpeakerPentakillController ()

@property (nonatomic, strong) UIImageView *moonView;
@property (nonatomic, strong) UIImageView *sunView;

@property (nonatomic, strong) UIButton *sunBtn;
@property (nonatomic, strong) UIButton *moonBtn;

@property (nonatomic, strong) NSString *clockstatus;

@property (nonatomic, strong) NSString *num;  //弹框“知道了”计时器
@property (nonatomic, strong) NSMutableString *omit;  //弹框“省略号”计时器

@property (nonatomic, strong) UIView *werewolfView;

@property (nonatomic, strong) NSMutableDictionary *dic;//静音狼人数组

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation LRSpeakerPentakillController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //时钟状态改变发言状态置为关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(voiceActionClose)
                                                 name:LR_CLOCK_STATE_CHANGE
                                               object:nil];
    //首次设置时钟状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callBackcClockStatus)
                                                 name:LR_CLOCK_STATE_CHANGE
                                               object:nil];
    if(![self.roomModel.owner isEqualToString:kCurrentUsername]){
        //夜晚狼人下麦操作
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setCoverUI)
                                                     name:LR_Receive_ToBe_Audience_Notification
                                                   object:nil];
    }
    _num = @"2";
    _omit = [[NSMutableString alloc]initWithString:@""];
}

- (void)voiceActionClose{
    for (LRSpeakerCellModel *model in self.dataAry) {
        [self routerEventWithName:@"pkOffMicEventName" userInfo:@{@"key" : model}];
    }
    
}

- (void)_setupSubViews {
    [super _setupSubViews];
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
    [self addView];//添加内容给狼人正在发言状态Ui   执行多次需要重新触发定时器
    
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
        [self.sunBtn addTarget:self action:@selector(adminSwichClock:) forControlEvents:UIControlEventTouchUpInside];
        self.moonBtn.tag = LRTerminator_night;
        [self.moonBtn addTarget:self action:@selector(adminSwichClock:) forControlEvents:UIControlEventTouchUpInside];
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
    
    //只有在狼人杀模式下，白天/夜晚的切换才存在
    self.schedule.hidden = NO;
    [self setupClockPic:[self getCurrentClock]];
}
//时钟状态改变回调
- (void)callBackcClockStatus {
    [self setupClockPic:LRSpeakHelper.sharedInstance.clockStatus];
    //注册狼人杀房间通知在房间模式设定之后，防止第一次进入房间弹窗
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name:LR_CLOCK_STATE_CHANGE
                                               object:nil];
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
- (void)adminSwichClock:(UIButton*)btn{
    LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"提示" info:@"您将要进行白天黑夜模式的切换，\n操作后所有人的发言状态将被初始化。\n确认操作么？"];
    LRAlertAction *confirm = [LRAlertAction alertActionTitle:@"确认" callback:^(LRAlertController *_Nonnull          alertContoller){
        long tag = btn.tag;
        if(tag == 1 && [[self getCurrentClock]isEqualToString:@"LRTerminator_night"]){
            [self setupClockPic:@"LRTerminator_dayTime"];
        }else if(tag == 2  && [[self getCurrentClock]isEqualToString:@"LRTerminator_dayTime"]){
            [self setupClockPic:@"LRTerminator_night"];
            if(![LRSpeakerPentakillCell.sharedInstance.identity isEqualToString:@"pentakill"]){
                [self addView];//添加内容给狼人正在发言状态Ui   执行多次需要重新触发定时器
            }
            if([self.clockstatus isEqualToString:@"LRTerminator_night"] &&
               [LRSpeakerPentakillCell.sharedInstance.identity isEqualToString:@"villager"]){
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
    NSLog(@"\n---------->?currentuser:%@",kCurrentUsername);
    if(![self.roomModel.owner isEqualToString:kCurrentUsername]){
        NSString *clock = [noti object];
        NSLog(@"\n-------------->notificationClock:    %@",clock);
        
        LRAlertController *alert;
        if([LRSpeakHelper.sharedInstance.clockStatus isEqualToString:@"LRTerminator_dayTime"]){
            alert = [LRAlertController showClockChangeAlertWithTitle:@"天亮了"
                                                                info:@"目前已经切换至白天,所有的设置将恢复默认。\n您可以点击身份图标任意切换角色体验。"
                                                          clockState:@"LRTerminator_dayTime"];
        }else{
            alert = [LRAlertController showClockChangeAlertWithTitle:@"夜晚降临"
                                                                info:@"目前已经切换至夜晚，只有狼人主播可以\n在夜晚发言。所有的设置将恢复默认。\n请重新点击发言按钮发言。"
                                                          clockState:@"LRTerminator_night"];
        }
        LRAlertAction *confirm = [LRAlertAction alertActionTitle:@"知道了  (3)" callback:^(LRAlertController *_Nonnull          alertContoller){
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //定时器延迟时间
        NSTimeInterval delayTime = 1.0f;
        
        //定时器间隔时间
        NSTimeInterval timeInterval = 1.0f;
        
        //设置开始时间
        dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
        //使用全局队列创建计时器
        dispatch_source_t _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue1);
        //设置计时器
        dispatch_source_set_timer(_sourceTimer,startDelayTime,timeInterval*NSEC_PER_SEC,0.1*NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(_sourceTimer, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"知道了  (%@)",self.num];
                [confirm setTitle:str forState:UIControlStateNormal];
                [self setupNum];
            });
            if([self.num intValue] < 1){
                self.num = @"2";
                dispatch_source_cancel(_sourceTimer);
                [alert dismissViewControllerAnimated:YES completion:nil];
            }
        });
        dispatch_resume(_sourceTimer);
        
        [self setupClockPic:clock];
        if([clock isEqualToString:@"LRTerminator_night"] && ![LRSpeakerPentakillCell.sharedInstance.identity isEqualToString:@"pentakill"]){
            [self addView];//添加内容给狼人正在发言状态Ui   执行多次需要重新触发定时器
        }
        if([self.clockstatus isEqualToString:@"LRTerminator_night"] &&
           [LRSpeakerPentakillCell.sharedInstance.identity isEqualToString:@"villager"]){
            [self muteWereWolf];// 夜晚村民静音狼人
        }else{
            [self reMuteWereWolf];//白天村民重新监听狼人说话
        }
    }
}
- (void)setupNum{
    int temp = [self.num intValue];
    temp--;
    self.num = [NSString stringWithFormat:@"%d",temp];
}

//设置当前时钟昼夜图片
- (void)setupClockPic:(NSString *)clock{
    UIImage *ImageSun;
    UIImage *ImageMoon;
    if([clock isEqualToString:@"LRTerminator_dayTime"]){
        ImageSun = [UIImage imageNamed:@"sun"];
        ImageMoon = [UIImage imageNamed:@"emptymoon"];
    }else if([clock isEqualToString:@"LRTerminator_night"]){
        ImageSun = [UIImage imageNamed:@"emptysun"];
        ImageMoon = [UIImage imageNamed:@"moon"];
    }
    _sunView.image = ImageSun;
    _moonView.image = ImageMoon;
    [self setCurrentClock:clock];
}

//获取当前时间钟：白昼/夜晚
- (NSString *)getCurrentClock{
    self.clockstatus = LRSpeakHelper.sharedInstance.clockStatus;
    if([_clockstatus isEqualToString:@"LRTerminator_dayTime"]){
        return @"LRTerminator_dayTime";
    }else if([_clockstatus isEqualToString:@"LRTerminator_night"]){
        return @"LRTerminator_night";
    }
    return @"";
}

//改变当前时钟状态
- (void)setCurrentClock:(NSString *)newClock{
    self.clockstatus = newClock;
    LRSpeakHelper.sharedInstance.clockStatus = _clockstatus;
    // 修改身份状态显示/隐藏
    [LRSpeakerPentakillCell.sharedInstance updateIdentity];
    //主播身份是村民并且时钟是夜晚，主播列表遮掩UI
    if(![LRSpeakerPentakillCell.sharedInstance.identity isEqualToString:@"pentakill"] && [_clockstatus isEqualToString:@"LRTerminator_night"]){
        [_omit setString:@""];
        self.tableView.hidden = YES;
        self.werewolfView.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        self.werewolfView.hidden = YES;
        self.num = @"2";//重置定时器初始值
    }
    //是房间管理员才可以修改server的时钟状态
    if(self.roomModel.owner == kCurrentUsername){
        [EMClient.sharedClient.conferenceManager setConferenceAttribute:[NSString stringWithFormat:@"clockStatus%@",self.roomModel.owner] value:_clockstatus completion:^(EMError *aError)
         {}];
    }
}

//夜晚狼人下麦操作
- (void)setCoverUI {
    LRSpeakerPentakillCell.sharedInstance.identity = @"";
    [_omit setString:@""];
    self.tableView.hidden = YES;
    self.werewolfView.hidden = NO;
    [self addView];
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
    [self.tableView reloadData];
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
        [self.tableView reloadData];
    }
}

- (UIView *)werewolfView {
    if(!_werewolfView) {
        _werewolfView = [[UIView alloc]initWithFrame:CGRectZero];
        _werewolfView.backgroundColor = RGBACOLOR(255,255,255,0.3);
    }
    return _werewolfView;
}
//夜晚村民遮掩UI
- (void)addView {
    UIImageView *icon = [[UIImageView alloc]init];
    [_werewolfView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        make.left.equalTo(self.werewolfView.mas_left).offset(15);
        make.top.equalTo(self.werewolfView.mas_top).offset(20);
    }];
    icon.image = [UIImage imageNamed:@"werewolf"];
    
    UILabel *title = [[UILabel alloc]init];
    [_werewolfView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(5);
        make.left.equalTo(self.werewolfView.mas_left).offset(15);
        make.right.equalTo(self.werewolfView.mas_right).offset(-15);
        make.height.equalTo(@35);
    }];
    [title setText:@"夜晚狼人正在发言..."];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:20];
    title.adjustsFontSizeToFitWidth = YES;
    
    UILabel *content = [[UILabel alloc]init];
    [_werewolfView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(5);
        make.left.equalTo(self.werewolfView).offset(15);
        make.right.equalTo(self.werewolfView.mas_right).offset(-15);
        make.height.equalTo(@130);
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    NSString *common = @"目前正在夜晚发言，只有狼人主播可以在夜晚发言。\n请等待管理员切换成白天模式，恢复全员自由发言。\n请等待管理员切换至白天。\n\n\n\n\n\n";
    content.attributedText = [[NSAttributedString alloc] initWithString:common attributes:ats];
    content.numberOfLines = 0;
    [content sizeToFit];
    content.textColor = RGBACOLOR(255, 255, 255, 1);
    content.font = [UIFont systemFontOfSize:14];
    content.adjustsFontSizeToFitWidth = YES;
    
//     __weak typeof(self) weakSelf = self;
//     if (@available(iOS 10.0, *)) {
//     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.75 repeats:YES block:^(NSTimer * _Nonnull timer){
//     [weakSelf timeRun:title];
//     }];
//     } else {
//     // Fallback on earlier versions
//     }
    
}

- (void)timeRun:(UILabel *)title{
    
    [_omit appendString:@"."];
    [title setText:[NSString stringWithFormat:@"夜晚狼人正在发言%@",self.omit]];
    if([_omit isEqualToString:@"..."]){
        [_omit setString:@""];
    }
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

- (NSMutableDictionary *)dic {
    if(!_dic){
        _dic = [[NSMutableDictionary alloc]init];
    }
    return _dic;
}
@end
