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
+ (LRAlertAction *)alertActionTitle:(NSString *)aTitle callback:(LRAlertActionCallback)aCallBack;
@end

typedef void(^CloseBlock)(void);


typedef enum : NSUInteger {
    LRAlertType_Success,
    LRAlertType_Warning,
    LRAlertType_Error,
    LRAlertType_None
} LRAlertType;

@interface LRAlertController : UIViewController

@property (nonatomic, copy) CloseBlock closeBlock;
@property (nonatomic, strong) UITextField *textField;

+ (LRAlertController *)showAlertWithType:(LRAlertType)aType
                                    title:(NSString *)aTitle
                                     info:(NSString * _Nullable)aInfo;

+ (LRAlertController *)showAlertWithTitle:(NSString *)aTitle
                                     info:(NSString * _Nullable)aInfo;

- (void)addAction:(LRAlertAction *)aAction;

@end

NS_ASSUME_NONNULL_END
