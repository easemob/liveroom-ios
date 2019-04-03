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
@interface LRAlertController : UIViewController

@property (nonatomic, copy) CloseBlock closeBlock;
@property (nonatomic, strong) UITextField *textField;

+ (LRAlertController *)showAlertWithImage:(UIImage * _Nullable)aImage
                               imageColor:(UIColor *)aColor
                                    title:(NSString *)aTitle
                                     info:(NSString *)aInfo;

- (void)addAction:(LRAlertAction *)aAction;

@end

NS_ASSUME_NONNULL_END
