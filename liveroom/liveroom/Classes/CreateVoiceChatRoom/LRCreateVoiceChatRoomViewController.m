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

    [self.voiceChatroomIDTextField setupTextField];
    [self.voiceChatroomIDTextField strokeWithColor:LRStrokeWhite];
    
    [self.passwordTextField setupTextField];
    [self.passwordTextField strokeWithColor:LRStrokeWhite];
    
//    NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/create/talk/room";
//    NSDictionary *parameters = @{@"roomName":@"chatroom1",
//                                 @"password":@"123456",
//                                 @"desc":@"desc",
//                                 @"allowAudienceTalk":@true,
//                                 @"imChatRoomMaxusers":@100,
//                                 @"confrDelayMillis":@3600
//                                 };
//    [[LRRequestManager sharedInstance] postNetworkRequestWithUrl:url requestBody:parameters token:@"" completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
//        NSLog(@"result---%@,----%@", result,error);
//    }];
    
//    NSString *url = @"http://turn2.easemob.com:8082/app/huangcl/delete/talk/room/79230364876801";
//    [[LRRequestManager sharedInstance] deleteNetworkRequestWithUrl:url token:@"" completion:^(NSString * _Nonnull result, NSError * _Nonnull error) {
//        NSLog(@"result---%@,----%@", result,error);
//    }];
    
    NSString *url = @"http://turn2.easemob.com:8082/app/talk/rooms/0/10";
    [[LRRequestManager sharedInstance] getNetworkRequestWithUrl:url
                                                          token:@""
                                                     completion:^(NSString * _Nonnull result, NSError * _Nonnull error)
     {
        NSLog(@"result---%@,----%@", result,error);
    }];
    
    
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
