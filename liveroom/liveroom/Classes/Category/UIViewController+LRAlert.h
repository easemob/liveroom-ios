//
//  UIViewController+LRAlert.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/13.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LRAlert)
- (void)showErrorAlertWithTitle:(NSString *)aTitle info:(NSString *)aInfo;
@end

NS_ASSUME_NONNULL_END
