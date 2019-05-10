//
//  UIViewController+LRAlert.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/13.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "UIViewController+LRAlert.h"
#import "Headers.h"

@implementation UIViewController (LRAlert)
- (void)showErrorAlertWithTitle:(NSString *)aTitle info:(NSString *)aInfo {
    LRAlertController *alert = [LRAlertController showErrorAlertWithTitle:aTitle info:aInfo];
//    LRAlertAction *action = [LRAlertAction alertActionTitle:@"确定" callback:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showTipsAlertWithTitle:(NSString *)aTitle info:(NSString *)aInfo {
    LRAlertController *alert = [LRAlertController showTipsAlertWithTitle:aTitle info:aInfo];
    LRAlertAction *action = [LRAlertAction alertActionTitle:@"确定" callback:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
