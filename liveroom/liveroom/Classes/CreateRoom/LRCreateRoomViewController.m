//
//  LRCreateRoomViewController.m
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/12.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRCreateRoomViewController.h"
#import "UIViewController+LRAlert.h"
#import "LRTypes.h"
#import "LRSpeakerPentakillCell.h"
#import "LRSettingSwitch.h"

#define kPadding 16
@interface LRCreateRoomViewController ()<LRSettingSwitchDelegate>
{
    LRRoomType _type;
    NSString *_roomType;
}
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *voiceChatroomIDTextField;    //房间名
@property (nonatomic, strong) UITextField *passwordTextField;           //密码
@property (nonatomic, strong) LRSettingSwitch *pwdSwitch;              //免密开关
@property (nonatomic, strong) UILabel *chatroomIDLabel;               //房间名规则
@property (nonatomic, strong) UILabel *passwordLabel;                  //密码规则
@property (nonatomic, strong) UIView *speakerTypeView;                 //模式view
@property (nonatomic, strong) UILabel *speakerTypeTextLabel;           //模式选择
@property (nonatomic, strong) UILabel *speakerTypeLabel;               //模式设置

@property (nonatomic, strong) UIView *identityTypeView;
@property (nonatomic, strong) UILabel *identityTypeTextlabel;
@property (nonatomic, strong) UILabel *identityTypelabel;
@property (nonatomic, strong) NSString *tempIdentity;

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation LRCreateRoomViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.voiceChatroomIDTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = LRRoomType_Communication;
    _roomType = @"communication";
    [self _setupSubviews];
}

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor blackColor];
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 10, 15);
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
        make.left.equalTo(self.view);
        make.width.equalTo(@45);
        make.height.equalTo(@25);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"创建 CreateVoiceChatroom";
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.closeButton.imageView);
    }];
    
    self.voiceChatroomIDTextField = [[UITextField alloc] init];
    self.voiceChatroomIDTextField.placeholder = @"房间 name";
    [self.voiceChatroomIDTextField setupTextField];
    [self.voiceChatroomIDTextField strokeWithColor:LRStrokeLowBlack];
    [self.view addSubview:self.voiceChatroomIDTextField];
    [self.voiceChatroomIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    self.chatroomIDLabel = [[UILabel alloc] init];
    self.chatroomIDLabel.text = @"房间号可以由字母、数字组成，不支持中文。Room numbers can be composed of letters and numbers, and Chinese is not supported.";
    [self.chatroomIDLabel setTextColor:RGBACOLOR(255, 255, 255, 0.3)];
    self.chatroomIDLabel.numberOfLines = 2;
    self.chatroomIDLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.chatroomIDLabel];
    [self.chatroomIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceChatroomIDTextField.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"密码 password";
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeLowBlack];
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatroomIDLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    self.pwdSwitch = [[LRSettingSwitch alloc]init];
    [self.view addSubview:self.pwdSwitch];
    [self.pwdSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_top).offset(12);
        make.right.equalTo(self.passwordTextField.mas_right).offset(-12);
        make.width.equalTo(@38);
        make.height.equalTo(@24);
    }];
    self.pwdSwitch.delegate = self;
    [self.pwdSwitch setOn:true animated:YES];
    [self.pwdSwitch setupTagBack:38 height:24];
    
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = @"请输入密码不能为空。Please enter a password that cannot be empty.";
    [self.passwordLabel setTextColor:RGBACOLOR(255, 255, 255, 0.3)];
    self.passwordLabel.numberOfLines = 2;
    self.passwordLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
    }];
    
    self.speakerTypeView = [[UIView alloc] init];
    [self.speakerTypeView strokeWithColor:LRStrokeLowBlack];
    self.speakerTypeView.backgroundColor = LRColor_HeightBlackColor;
    self.speakerTypeView.userInteractionEnabled = YES;
    [self.view addSubview:self.speakerTypeView];
    [self.speakerTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakerTypeTap)];
    [self.speakerTypeView addGestureRecognizer:tap];
    
    self.speakerTypeTextLabel = [[UILabel alloc] init];
    self.speakerTypeTextLabel.text = @"自由麦模式 Communication";
    self.speakerTypeTextLabel.font = [UIFont systemFontOfSize:17];
    [self.speakerTypeTextLabel setTextColor:[UIColor whiteColor]];
    [self.speakerTypeView addSubview:self.speakerTypeTextLabel];
    [self.speakerTypeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speakerTypeView).offset(15);
        make.centerY.equalTo(self.speakerTypeView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"extend"];
    [self.speakerTypeView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.speakerTypeView);
        make.right.equalTo(self.speakerTypeView).offset(-15);
    }];
    
    self.speakerTypeLabel = [[UILabel alloc] init];
    self.speakerTypeLabel.text = @"设置房间的玩法模式。Set up the play mode of the room.";
    [self.speakerTypeLabel setTextColor:RGBACOLOR(255, 255, 255, 0.3)];
    self.speakerTypeLabel.numberOfLines = 2;
    self.speakerTypeLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.speakerTypeLabel];
    [self.speakerTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakerTypeView.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
    }];
    
    self.submitButton = [[UIButton alloc] init];
    [self.submitButton setTitle:@"创建 create" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[UIColor whiteColor]];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakerTypeLabel.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
}

//设置狼人杀身份选择
- (void)setupWereWolve
{
    NSLog(@"\npwd       %f",self.passwordTextField.frame.origin.y);
    _identityTypeView = [[UIView alloc] init];
    [_identityTypeView strokeWithColor:LRStrokeLowBlack];
    _identityTypeView.backgroundColor = LRColor_HeightBlackColor;
    _identityTypeView.userInteractionEnabled = YES;
    [self.view addSubview:_identityTypeView];
    [_identityTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakerTypeLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
    UITapGestureRecognizer *tapIdentity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityTypeTap)];
    [_identityTypeView addGestureRecognizer:tapIdentity];
    
    _identityTypeTextlabel = [[UILabel alloc] init];
    _identityTypeTextlabel.text = @"狼人 Werewlof";
    
    _tempIdentity = @"pentakill";
    //[LRSpeakHelper setupIdentity:@"pentakill"];
    
    _identityTypeTextlabel.font = [UIFont systemFontOfSize:18];
    [_identityTypeTextlabel setTextColor:[UIColor whiteColor]];
    [_identityTypeView addSubview:_identityTypeTextlabel];
    [_identityTypeTextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.identityTypeView).offset(15);
        make.centerY.equalTo(self.identityTypeView);
    }];
    
    UIImageView *imageIdentity = [[UIImageView alloc] init];
    imageIdentity.image = [UIImage imageNamed:@"extend"];
    [self.identityTypeView addSubview:imageIdentity];
    [imageIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.identityTypeView);
        make.right.equalTo(self.identityTypeView).offset(-15);
    }];
    
    _identityTypelabel = [[UILabel alloc] init];
    _identityTypelabel.text = @"初始化自己的身份。Set up the play mode of the room.";
    [_identityTypelabel setTextColor:RGBACOLOR(255, 255, 255, 0.3)];
    _identityTypelabel.numberOfLines = 2;
    _identityTypelabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_identityTypelabel];
    [self.view addSubview:_identityTypelabel];
    [_identityTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityTypeView.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
    }];
    
    [self.submitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityTypelabel.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
    
}

//创建房间时房主添加狼人杀身份选择
- (void)identityTypeTap
{
    LRAlertController *alert = [LRAlertController showIdentityAlertWithTitle:@"选择上麦身份" info:@"提交上麦参与体验.\n需要先选择上麦后的身份。\n您可以选择狼人或者村民，进行点击确认。"];
    LRAlertAction *werewolf = [LRAlertAction alertActionTitle:@"狼人 Werewolf" callback:^(LRAlertController *_Nonnull alertController)
                               {
                                   self.identityTypeTextlabel.text = @"狼人 Werewolf";
                                   self.tempIdentity = @"pentakill";
                                   
                               }];
    LRAlertAction *villager = [LRAlertAction alertActionTitle:@"村民 Villager" callback:^(LRAlertController *_Nonnull alertController)
                               {
                                   self.identityTypeTextlabel.text = @"村民 Villager";
                                   self.tempIdentity = @"villager";
                               }];
    [alert addAction:werewolf];
    [alert addAction:villager];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//隐藏狼人杀身份选择
- (void)removeIdentity
{
    self.identityTypeView.hidden = YES;
    self.identityTypelabel.hidden = YES;
    [self.submitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakerTypeLabel.mas_bottom).offset(44);
        make.left.equalTo(self.view).offset(kPadding);
        make.right.equalTo(self.view).offset(-kPadding);
        make.height.equalTo(@48);
    }];
}

#pragma mark UITapGestureRecognizer
- (void)speakerTypeTap
{
    LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"提示" info:@"狼人杀模式下遵循狼人杀玩法规则;\n自由麦模式下所有主播可以自由发言;\n主持模式下管理员分配的主播获得发言权;\n抢麦模式下所有主播通过抢麦获得发言权。"];
    
    LRAlertAction *communicationAction = [LRAlertAction alertActionTitle:@"自由麦模式 Communication"
                                                                callback:^(LRAlertController * _Nonnull alertController)
                                          {
                                              self.speakerTypeTextLabel.text = @"自由麦模式 Communication";
                                              self->_type = LRRoomType_Communication;
                                              self->_roomType = @"communication";
                                              [self removeIdentity];
                                          }];
    
    LRAlertAction *hostAction = [LRAlertAction alertActionTitle:@"主持模式 Host"
                                                       callback:^(LRAlertController * _Nonnull alertController)
                                 {
                                     self.speakerTypeTextLabel.text = @"主持模式 Host";
                                     self->_type = LRRoomType_Host;
                                     self->_roomType = @"host";
                                     [self removeIdentity];
                                 }];
    
    LRAlertAction *monopolyAction = [LRAlertAction alertActionTitle:@"抢麦模式 Monopoly"
                                                           callback:^(LRAlertController * _Nonnull alertController)
                                     {
                                         self.speakerTypeTextLabel.text = @"抢麦模式 Monopoly";
                                         self->_type = LRRoomType_Monopoly;
                                         self->_roomType = @"monopoly";
                                         [self removeIdentity];
                                     }];
    
    LRAlertAction *werewolvesAction = [LRAlertAction alertActionTitle:@"狼人杀模式 Pentakill"
                                                             callback:^(LRAlertController * _Nonnull
                                                                        alertCONTROLLER)
                                       {
                                           self.speakerTypeTextLabel.text = @"狼人杀模式 Pentakill";
                                           self->_type = LRRoomType_Pentakill;
                                           self->_roomType = @"pentakill";
                                           [self setupWereWolve];
                                       }];
    
    [alert addAction:werewolvesAction];
    [alert addAction:communicationAction];
    [alert addAction:hostAction];
    [alert addAction:monopolyAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)submitButtonAction
{
    if (self.voiceChatroomIDTextField.text.length == 0) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"请输入房间号"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if ([self hasChinese:self.voiceChatroomIDTextField.text]) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"房间号不支持中文"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.passwordTextField.text.length == 0 && self.pwdSwitch.isOn) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"请输入房间密码"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.passwordTextField.text.length > 16 || self.voiceChatroomIDTextField.text.length > 16) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"创建失败，房间名或密码长度过长，不能超过16位"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    id body = @{@"roomName":self.voiceChatroomIDTextField.text,
                @"password":(_pwdSwitch.isOn) ? self.passwordTextField.text : @"",
                @"allowAudienceTalk":@YES,
                @"imChatRoomMaxusers":@([options.audioQuality intValue]),
                @"desc":@"desc",
                @"confrDelayMillis":@(360000*1000),
                @"memRole":@1,
                @"roomtype":self->_roomType
                };
    
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"正在创建房间..."];
    NSString *url = [NSString stringWithFormat:@"http://tcapp.easemob.com/app/%@/create/talk/room", kCurrentUsername];
    [LRRequestManager.sharedInstance requestWithMethod:@"POST" urlString:url parameters:body token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"创建房间-----%@", result);
             [weakSelf hideHud];
             if (!error) {
                 NSMutableDictionary *dic = [result mutableCopy];
                 if (dic) {
                     [dic setObject:weakSelf.voiceChatroomIDTextField.text forKey:@"roomname"];
                     [dic setObject:weakSelf.passwordTextField.text forKey:@"rtcConfrPassword"];
                     [dic setObject:EMClient.sharedClient.currentUsername forKey:@"ownerName"];
                     [dic setObject:@(self->_type) forKey:@"type"];
                     if(self->_type == LRRoomType_Pentakill){
                         [dic setObject:self.tempIdentity forKey:@"identity"];
                         [dic setObject:@"" forKey:@"clockStatus"];
                     }
                 }
                 [[NSNotificationCenter defaultCenter] postNotificationName:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:dic];
             }else {
                 [self showErrorAlertWithTitle:@"失败" info:error.domain];
             }
         });
     }];
}

- (BOOL)hasChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark ButtonAction
- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _tempIdentity = @"";// 创建房间中断，重置狼人杀身份
}
//密码开关
#pragma mark LRSettingSwitchDelegate
- (void)settingSwitchWithValueChanged:(LRSettingSwitch *)aSwitch
{
    self.pwdSwitch.isOn = !aSwitch;
    //可选密码开关
    if(!aSwitch.isOn){
        self.passwordTextField.placeholder = @"公开房间无需设置密码";
        self.passwordTextField.backgroundColor = [UIColor blackColor];
        [self.passwordTextField strokeWithColor:LRStrokeMiddleBlack];
        self.passwordLabel.text = @"如果需要创建私密房间，请打开密码开关";
        self.passwordTextField.userInteractionEnabled = NO;
        self.passwordTextField.enabled = NO;
    }else{
        self.passwordTextField.placeholder = @"密码 password";
        self.passwordTextField.backgroundColor = LRColor_HeightBlackColor;
        [self.passwordTextField strokeWithColor:LRStrokeLowBlack];
        self.passwordLabel.text = @"请输入密码不能为空。Please enter a password that cannot be empty.";
        self.passwordTextField.userInteractionEnabled = YES;
        self.passwordTextField.enabled = YES;
    }
    [self.pwdSwitch setupTagBack:38 height:24];
}

@end


@implementation LRCreateBtn

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}


@end
