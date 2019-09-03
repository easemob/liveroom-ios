//
//  LRAlertController.h
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/4/1.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LRAlertController;
typedef void(^LRAlertActionCallback)(LRAlertController *alertController);

@interface LRAlertAction : UIButton
+ (LRAlertAction *)alertActionTitle:(NSString *)aTitle callback:(LRAlertActionCallback _Nullable)aCallBack;
@end

typedef void(^CloseBlock)(void);

@interface LRAlertController : UIViewController
@property (nonatomic, copy) CloseBlock closeBlock;
@property (nonatomic, strong) UITextField *textField;

+ (LRAlertController *)showSuccessAlertWithTitle:(NSString *)aTitle
                                            info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showTipsAlertWithTitle:(NSString *)aTitle
                                         info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showErrorAlertWithTitle:(NSString *)aTitle
                                          info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showTextAlertWithTitle:(NSString *)aTitle
                                         info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showIdentityAlertWithTitle:(NSString *)aTitle
                                             info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showClockChangeAlertWithTitle:(NSString *)aTitle
                                                info:(NSString * _Nullable)aInfo
                                          clockState:(NSString *)lrterminator;

- (void)addAction:(LRAlertAction *)aAction;

@end


NS_ASSUME_NONNULL_END
