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

#define kPadding 16
@interface LRCreateRoomViewController ()
{
    LRRoomType _type;
}
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *voiceChatroomIDTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *chatroomIDLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UIView *speakerTypeView;
@property (nonatomic, strong) UILabel *speakerTypeTextLabel;
@property (nonatomic, strong) UILabel *speakerTypeLabel;
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
    self.speakerTypeTextLabel.text = @"互动模式";
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

#pragma mark ButtonAction
- (void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITapGestureRecognizer
- (void)speakerTypeTap
{
    LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:@"提示" info:@"互动模式下所有主播可以自由发言;\n抢麦模式下所有主播通过抢麦获得发言权;\n主持模式下管理员分配的主播获得发言权;\n"];

    LRAlertAction *communicationAction = [LRAlertAction alertActionTitle:@"互动模式"
                                                                callback:^(LRAlertController * _Nonnull alertController)
                                          {
                                              self.speakerTypeTextLabel.text = @"互动模式";
                                              self->_type = LRRoomType_Communication;
                                          }];
    
    LRAlertAction *monopolyAction = [LRAlertAction alertActionTitle:@"抢麦模式"
                                                           callback:^(LRAlertController * _Nonnull alertController)
                                     {
                                         self.speakerTypeTextLabel.text = @"抢麦模式";
                                         self->_type = LRRoomType_Monopoly;
                                     }];
    
    LRAlertAction *hostAction = [LRAlertAction alertActionTitle:@"主持模式"
                                                       callback:^(LRAlertController * _Nonnull alertController)
                                 {
                                     self.speakerTypeTextLabel.text = @"主持模式";
                                     self->_type = LRRoomType_Host;
                                 }];
    
    
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
    
    if (self.passwordTextField.text.length == 0) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"请输入房间密码"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.passwordTextField.text.length > 16) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"密码最多16位"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    LRRoomOptions *options = [LRRoomOptions sharedOptions];
    id body = @{@"roomName":self.voiceChatroomIDTextField.text,
                @"password":self.passwordTextField.text,
                @"allowAudienceTalk":@YES,
                @"imChatRoomMaxusers":@([options.audioQuality intValue]),
                @"desc":@"desc",
                @"confrDelayMillis":@3600,
                @"memRole":@1
                };
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"http://turn2.easemob.com:8082/app/%@/create/talk/room", kCurrentUsername];;
    
    [LRRequestManager.sharedInstance requestWithMethod:@"POST" urlString:url parameters:body token:nil completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSMutableDictionary *dic = [result mutableCopy];
                if (dic) {
                    [dic setObject:weakSelf.voiceChatroomIDTextField.text forKey:@"roomname"];
                    [dic setObject:weakSelf.passwordTextField.text forKey:@"rtcConfrPassword"];
                    [dic setObject:EMClient.sharedClient.currentUsername forKey:@"ownerName"];
                    [dic setObject:@(self->_type) forKey:@"type"];
                }
                [NSNotificationCenter.defaultCenter postNotificationName:LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED object:dic];
            }else {
                [self showErrorAlertWithTitle:@"失败" info:error.domain];
            }
        });
    }];
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
