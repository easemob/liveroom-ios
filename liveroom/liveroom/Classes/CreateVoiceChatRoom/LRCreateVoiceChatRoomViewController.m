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
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation LRCreateVoiceChatRoomViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(LRSafeAreaTopHeight);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
}

- (void)_setupSubviews {
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
    if (self.voiceChatroomIDTextField.text.length == 0) {
        LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:@"错误 Error" info:@"请输入房间号"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    id body = @{@"roomName":self.voiceChatroomIDTextField.text,
                @"password":self.passwordTextField.text,
                @"allowAudienceTalk":@YES,
                @"imChatRoomMaxusers":@100,
                @"desc":@"desc",
                @"confrDelayMillis":@3600
                };
    
    __weak typeof(self) weakSelf = self;
    [LRRequestManager.sharedInstance postNetworkRequestWithUrl:@"http://turn2.easemob.com:8082/app/huangcl/create/talk/room" requestBody:body token:@"" completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                if (dic) {
                    [dic setObject:weakSelf.voiceChatroomIDTextField.text forKey:@"roomname"];
                    [dic setObject:@YES forKey:@"createMySelf"];
                }
                [NSNotificationCenter.defaultCenter postNotificationName:LR_NOTIFICATION_AFTER_CREATED_ROOM object:dic];
            }
        });
    }];
}

- (void)dealloc {
    NSLog(@"dealloc");
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
