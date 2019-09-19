//
//  LRLoginViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/27.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRLoginViewController.h"
#import "Headers.h"
#import "LRAlertController.h"

@interface LRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LRLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupSubViews];
}

- (void)_setupSubViews
{
    [self.usernameTextField setupTextField];
    [self.usernameTextField strokeWithColor:LRStrokeLowBlack];
    
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeLowBlack];
}


- (BOOL)validationInputInfo {
    NSString *uname = self.usernameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    if (uname.length == 0 || pwd.length == 0) {
        LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:@"错误 error"
                                                                             info:@"用户名或密码不能为空"];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - actions
// 登录
- (IBAction)loginAction:(id)sender
{
    if (![self validationInputInfo]) return;
    [self showHudInView:self.view hint:@"正在登录..."];
    __weak typeof(self) weakself = self;
    NSString *name = [self.usernameTextField.text lowercaseString];
    [LRChatHelper.sharedInstance asyncLoginWithUsername:name
                                             password:self.passwordTextField.text
                                           completion:^(NSString * _Nonnull errorInfo, BOOL success)
    {
        [weakself hideHud];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LR_ACCOUNT_LOGIN_CHANGED
                                                                object:@YES];
        }else {
            LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:@"登录失败"
                                                                                 info:errorInfo];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

// 注册
- (IBAction)registerAction:(id)sender
{
    if (![self validationInputInfo]) return;
    [self showHudInView:self.view hint:@"正在注册..."];
    __weak typeof(self) weakself = self;
    NSString *name = [self.usernameTextField.text lowercaseString];
    [LRChatHelper.sharedInstance asyncRegisterWithUsername:name
                                                password:self.passwordTextField.text
                                              completion:^(NSString * _Nonnull errorInfo, BOOL success)
     {
         [weakself hideHud];
         if (success) {
             LRAlertController *alertController = [LRAlertController showSuccessAlertWithTitle:@"注册成功"
                                                                                  info:nil];
             [self presentViewController:alertController animated:YES completion:nil];
         }else {
             LRAlertController *alertController = [LRAlertController showErrorAlertWithTitle:@"注册失败"
                                                                                  info:errorInfo];
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
}

- (IBAction)tapBackgroundAction:(id)sender
{
    [self.view endEditing:YES];
}

- (void)loginWithRegistStatus:(BOOL)isSucess
{
    if (isSucess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_ACCOUNT_LOGIN_CHANGED object:[NSNumber numberWithBool:YES]];
    }
}

@end
