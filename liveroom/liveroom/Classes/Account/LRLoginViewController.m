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
    [self.usernameTextField strokeWithColor:LRStrokeWhite];
    
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeWhite];
}


#pragma mark - actions
// 登录
- (IBAction)loginAction:(id)sender
{
    LRAlertController *alertController = [LRAlertController showAlertWithType:LRAlertType_Success
                                                                        title:@"正确 ok"
                                                                         info:@"账号注册成功。 Account registeration was successful."];

    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入密码";
    alertController.textField = textField;
    
    LRAlertAction *action = [LRAlertAction alertActionTitle:@"测试"
                                                   callback:^(LRAlertController * _Nonnull alertController) {
                                                       NSLog(@"alertController.textField.text -- %@",alertController.textField.text);
                                                   }];
    
    LRAlertAction *action1 = [LRAlertAction alertActionTitle:@"测试"
                                                    callback:^(LRAlertController * _Nonnull alertController) {
                                                        
                                                    }];
    
    [alertController addAction:action];
    [alertController addAction:action1];
    
    alertController.closeBlock = ^
    {
        NSLog(@"关闭");
    };
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 注册
- (IBAction)registerAction:(id)sender
{
    
    NSString *uname = self.usernameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    if (uname.length == 0 || pwd.length == 0) {
        LRAlertController *alertController = [LRAlertController showAlertWithType:LRAlertType_Error
                                                                             title:@"错误 error"
                                                                              info:@"用户名或密码不能为空"];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [LRImHelper.sharedInstance asyncRegisterWithUsername:uname
                                                password:pwd
                                              completion:^(NSString * _Nonnull errorInfo, BOOL success)
    {
        if (success) {
            LRAlertController *alertController = [LRAlertController showAlertWithType:LRAlertType_Success
                                                                                title:@"注册成功"
                                                                                 info:nil];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            LRAlertController *alertController = [LRAlertController showAlertWithType:LRAlertType_Error
                                                                                title:@"注册失败"
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
