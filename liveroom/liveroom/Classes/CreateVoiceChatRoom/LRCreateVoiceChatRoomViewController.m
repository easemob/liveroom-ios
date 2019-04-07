//
//  LRCreateVoiceChatRoomViewController.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/29.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRCreateVoiceChatRoomViewController.h"

@interface LRCreateVoiceChatRoomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *voiceChatroomIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LRCreateVoiceChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.voiceChatroomIDTextField setupTextField];
    [self.voiceChatroomIDTextField strokeWithColor:LRStrokeWhite];
    
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeWhite];
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)submitAction:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
