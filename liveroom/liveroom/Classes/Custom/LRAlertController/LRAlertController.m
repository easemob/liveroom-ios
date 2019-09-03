//
//  LRAlertController.m
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/4/1.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRAlertController.h"
#import "Headers.h"

#define kLRAlertItemHeight 45

@interface LRAlertAction ()
@property (nonatomic, copy) LRAlertActionCallback callback;
@end

@implementation LRAlertAction
+ (LRAlertAction *)alertActionTitle:(NSString *)aTitle
                           callback:(LRAlertActionCallback)aCallBack
{
    LRAlertAction *action = [LRAlertAction buttonWithType:UIButtonTypeCustom];
    [action setTitle:aTitle forState:UIControlStateNormal];
    action.callback = aCallBack;
    return action;
}


@end

typedef enum : NSUInteger {
    LRAlertType_Success,
    LRAlertType_Warning,
    LRAlertType_Error,
    LRAlertType_None,
    LRAlertType_Werewolves,
    LRAlertType_dayTime,
    LRAlertType_night} LRAlertType;


@interface LRAlertController () <UITextFieldDelegate>
{
    NSString *_title;
    NSString *_info;
    LRAlertType _type;
    NSMutableArray *_actionList;
}
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *otherView;

@end

@implementation LRAlertController

+ (LRAlertController *)showSuccessAlertWithTitle:(NSString *)aTitle
                                            info:(NSString * _Nullable)aInfo {
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_Success
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}


+ (LRAlertController *)showTipsAlertWithTitle:(NSString *)aTitle
                                         info:(NSString * _Nullable)aInfo {
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_Warning
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}

+ (LRAlertController *)showClockChangeAlertWithTitle:(NSString *)aTitle
                                                info:(NSString * _Nullable)aInfo
                                          clockState:(NSString *)lrterminator {
    LRAlertController *alertController;
    if([lrterminator isEqualToString:@"LRTerminator_dayTime"]){
        alertController = [[LRAlertController alloc] initWithType:LRAlertType_dayTime
                                                            title:aTitle
                                                             info:aInfo];
    }else{
        alertController = [[LRAlertController alloc] initWithType:LRAlertType_night
                                                            title:aTitle
                                                             info:aInfo];
    }
    
    return alertController;
}

+ (LRAlertController *)showIdentityAlertWithTitle:(NSString *)aTitle
                                             info:(NSString * _Nullable)aInfo {
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_Werewolves
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}

+ (LRAlertController *)showErrorAlertWithTitle:(NSString *)aTitle
                                          info:(NSString * _Nullable)aInfo {
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_Error
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}

+ (LRAlertController *)showTextAlertWithTitle:(NSString *)aTitle
                                         info:(NSString * _Nullable)aInfo {
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_None
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}



+ (LRAlertController *)showAlertWithType:(LRAlertType)aType
                                   title:(NSString *)aTitle
                                    info:(NSString * _Nullable)aInfo

{
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:aType
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}


+ (LRAlertController *)showAlertWithTitle:(NSString *)aTitle
                                     info:(NSString *)aInfo
{
    LRAlertController *alertController = [[LRAlertController alloc] initWithType:LRAlertType_None
                                                                           title:aTitle
                                                                            info:aInfo];
    return alertController;
}

- (instancetype)initWithType:(LRAlertType)aType
                       title:(NSString *)aTitle
                        info:(NSString * _Nullable)aInfo
{
    if (self = [super initWithNibName:@"LRAlertController" bundle:nil]) {
        [self _setupAnimation];
        _type = aType;
        _info = aInfo;
        _title = aTitle;
        _actionList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.textField) {
        [self registerKeyboardNotifiers];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    self.otherView.backgroundColor = [UIColor clearColor];
    [_alertView strokeWithColor:LRStrokeLowBlack];
    _alertView.backgroundColor = LRColor_HighLightColor;
    [self _setupImageView];
    self.titleLabel.text = _title;
    
    if (_info) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        self.infoLabel.attributedText = [[NSAttributedString alloc] initWithString:_info attributes:ats];
        self.infoLabel.textColor = RGBACOLOR(255, 255, 255, 1);
    }else {
        
    }
    
    if (self.textField) {
        [self _setupTextField];
    }
    
    [self _setupActions];
}

#pragma mark - public
- (void)addAction:(LRAlertAction *)aAction;
{
    if (!_actionList) {
        _actionList = [NSMutableArray array];
    }
    [_actionList addObject:aAction];
}

#pragma mark - notifiers
- (void)registerKeyboardNotifiers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

#pragma mark - actions
- (IBAction)closeBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    }];
}

#pragma mark - subViews

- (void)_setupImageView
{
    UIImage *image = nil;
    
    switch (_type) {
        case LRAlertType_Success:
        {
            image = [UIImage imageNamed:@"correct"];
        }
            break;
        case LRAlertType_Warning:
        {
            image = [UIImage imageNamed:@"warning"];
        }
            break;
        case LRAlertType_Error:
        {
            image = [UIImage imageNamed:@"error"];
        }
            break;
        case LRAlertType_Werewolves:
        {
            image = [UIImage imageNamed:@"werewolf"];
        }
            break;
        case LRAlertType_dayTime:
        {
            image = [UIImage imageNamed:@"sun"];
        }
            break;
        case LRAlertType_night:
        {
            image = [UIImage imageNamed:@"moon"];
        }
            break;
        default:
            break;
    }
    
    if (image) {
        self.showImage.image = image;
        self.showImage.layer.masksToBounds = YES;
        self.showImage.layer.cornerRadius = 2;
    }else {
        [self.showImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
        }];
    }
}

- (void)_setupTextField
{
    [self.textField strokeWithColor:LRStrokeLowBlack];
    [self.textField setupTextField];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.textColor = UIColor.whiteColor;
    self.textField.delegate = self;
    [self.alertView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel);
        make.right.equalTo(self.infoLabel);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(15);
        make.height.equalTo(@kLRAlertItemHeight);
        make.bottom.equalTo(self.otherView.mas_top).offset(-15);
    }];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topBackground)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)_setupActions
{
    if (!_actionList) {
        return;
    }
    
    for (int i = 0 ; i < _actionList.count; i++) {
        LRAlertAction *action = _actionList[i];
        [self _setupAction:action];
        BOOL isLatest = i == _actionList.count - 1;
        [self.otherView addSubview:action];
        [action mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.otherView).offset(0);
            make.right.equalTo(self.otherView).offset(0);
            make.top.equalTo(self.otherView).offset(i * (15 + kLRAlertItemHeight));
            make.height.equalTo([NSNumber numberWithFloat:kLRAlertItemHeight]);
            if (isLatest) {
                make.bottom.equalTo(self.otherView).offset(0);
            }
        }];
    }
}

- (void)_setupAnimation
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

#pragma mari - private
- (void)_setupAction:(LRAlertAction *)aAction;
{
    aAction.backgroundColor = [UIColor whiteColor];
    [aAction setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    aAction.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [aAction addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionClicked:(LRAlertAction *)aAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (aAction.callback) {
        aAction.callback(self);
    }
}

- (void)keyboardDidChanged:(NSNotification *)aNoti
{
    NSDictionary *userInfo = aNoti.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect alertFrame = [self.alertView convertRect:self.alertView.bounds toView:self.view];
    CGFloat keyboardTop = self.view.bounds.size.height - keyboardFrame.size.height;
    CGFloat currentBottom = alertFrame.origin.y + alertFrame.size.height;
    CGFloat needMovePx = 0;
    if (keyboardTop < currentBottom) {
        needMovePx = currentBottom - keyboardTop;
    }
    self.alertView.transform = CGAffineTransformMakeTranslation(0, -needMovePx);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - actions
- (void)topBackground {
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
}

@end
