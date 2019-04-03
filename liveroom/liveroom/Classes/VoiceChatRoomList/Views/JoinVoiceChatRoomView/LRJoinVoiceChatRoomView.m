//
//  LRJoinVoiceChatRoomView.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRJoinVoiceChatRoomView.h"
#import "Headers.h"

@interface LRJoinVoiceChatRoomView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *voiceChatRoomNameLabel;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *voiceChatRoomDetailsLabel;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *joinVoiceChatRoomButton;


@end

@implementation LRJoinVoiceChatRoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
    }
    return self;
}

- (void)_setupSubviews
{
    self.backgroundColor = [UIColor blackColor];
    
    self.voiceChatRoomNameLabel = [[UILabel alloc] init];
    self.voiceChatRoomNameLabel.textColor = [UIColor whiteColor];
//    self.voiceChatRoomNameLabel.text = @"聊天室1";
    [self addSubview:self.voiceChatRoomNameLabel];
    [self.voiceChatRoomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
    self.voiceChatRoomDetailsLabel = [[UILabel alloc] init];
//    self.chatRoomDetailsLabel.text = [self.voiceChatRoomDetails objectForKey:@""];
    self.voiceChatRoomDetailsLabel.text = @"聊天室详情介绍";
    self.voiceChatRoomDetailsLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.voiceChatRoomDetailsLabel];
    [self.voiceChatRoomDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceChatRoomNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@180);
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.placeholder = @"输入密码";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.delegate = self;
    [self addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceChatRoomDetailsLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@30);
    }];
    
    self.joinVoiceChatRoomButton = [[UIButton alloc] init];
    self.joinVoiceChatRoomButton.backgroundColor = [UIColor whiteColor];
    [self.joinVoiceChatRoomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.joinVoiceChatRoomButton addTarget:self action:@selector(joinVoiceChatRoomAction) forControlEvents:UIControlEventTouchUpInside];
    [self.joinVoiceChatRoomButton setTitle:@"观众加入" forState:UIControlStateNormal];
    [self addSubview:self.joinVoiceChatRoomButton];
    [self.joinVoiceChatRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@30);
    }];
}

#pragma mark ButtonAction
- (void)closeAction
{
    if ([self.delegate respondsToSelector:@selector(closeVoiceChatRoomView:)]) {
        [self.delegate closeVoiceChatRoomView:YES];
    }
}

- (void)joinVoiceChatRoomAction
{
    if ([self.delegate respondsToSelector:@selector(joinVoiceChatRoom:)]) {
        [self.delegate joinVoiceChatRoom:YES];
    }
}

- (void)setVoiceChatRoomName:(NSString *)voiceChatRoomName
{
    NSLog(@"voiceChatRoomName---%@",voiceChatRoomName);
    _voiceChatRoomName = voiceChatRoomName;
    self.voiceChatRoomNameLabel.text = voiceChatRoomName;
}

#pragma mark TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.passwordTextField endEditing:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


@end
