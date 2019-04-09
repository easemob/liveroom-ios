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
    LRAlertController *alertController = [LRAlertController showAlertWithImage:[UIImage imageNamed:@"warning"] imageColor:[UIColor orangeColor] title:@"正确 ok" info:@"账号注册成功。 Account registeration was successful."];

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
    LRAlertController *alertController = [LRAlertController showAlertWithImage:[UIImage imageNamed:@"correct"]
                                                                    imageColor:[UIColor greenColor]
                                                                         title:@"正确 ok"
                                                                          info:@"账号注册成功。 Account registeration was successful."];
    alertController.closeBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LR_ACCOUNT_LOGIN_CHANGED object:[NSNumber numberWithBool:YES]];
    };
    [self presentViewController:alertController animated:YES completion:nil];
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
