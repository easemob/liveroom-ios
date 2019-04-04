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

@interface LRAlertController () <UITextFieldDelegate>
{
    NSString *_title;
    NSString *_info;
    UIImage *_image;
    UIColor *_bgColor;
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

+ (LRAlertController *)showAlertWithImage:(UIImage *)aImage
                               imageColor:(UIColor *)aColor
                                    title:(NSString *)aTitle
                                     info:(NSString *)aInfo

{
    LRAlertController *alertController = [[LRAlertController alloc]
                                          initWithImage:aImage
                                          imageColor:aColor
                                          title:aTitle
                                          info:aInfo];
    return alertController;
}


+ (LRAlertController *)showAlertWithTitle:(NSString *)aTitle
                                     info:(NSString *)aInfo
{
    LRAlertController *alertController = [[LRAlertController alloc]
                                          initWithImage:nil
                                          imageColor:nil
                                          title:aTitle
                                          info:aInfo];
    return alertController;
}

- (instancetype)initWithImage:(UIImage *)aImage
                   imageColor:(UIColor *)aColor
                       title:(NSString *)aTitle
                        info:(NSString *)aInfo
{
    if (self = [super initWithNibName:@"LRAlertController" bundle:nil]) {
        [self _setupAnimation];
        _image = aImage;
        _info = aInfo;
        _title = aTitle;
        _bgColor = aColor;
        _actionList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.textField) {
        [self registerKeyboardNotifiers];
    }
}

- (void)viewDidLayoutSubviews
{
    [_alertView strokeWithColor:LRStrokeWhite];
    _alertView.backgroundColor = LRColor_HighLightColor;
    [self _setupImageView];
    self.titleLabel.text = _title;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    self.infoLabel.attributedText = [[NSAttributedString alloc] initWithString:_info attributes:ats];
    self.infoLabel.textColor = RGBACOLOR(255, 255, 255, 1);

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
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.closeBlock) {
            self.closeBlock();
        }
    }];
}

#pragma mark - subViews

- (void)_setupImageView
{
    if (_image) {
        self.showImage.image = _image;
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
    
    if (_bgColor) {
        self.showImage.backgroundColor = _bgColor;
    }
}

- (void)_setupTextField
{
    [self.textField setupTextField];
    [self.textField strokeWithColor:LRStrokeWhite];
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
    if (aAction.callback) {
        aAction.callback(self);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDidChanged:(NSNotification *)aNoti
{
    NSDictionary *userInfo = aNoti.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect textFieldFrame = [self.textField convertRect:self.textField.bounds toView:self.view];
    CGFloat keyboardTop = self.view.bounds.size.height - keyboardFrame.size.height;
    CGFloat currentBottom = textFieldFrame.origin.y + textFieldFrame.size.height;
    CGFloat needMovePx = 0;
    if (keyboardTop < currentBottom) {
        needMovePx = currentBottom - keyboardTop;
    }
    if (needMovePx != 0) {
        CGRect frame = self.alertView.frame;
        frame.origin.y -= needMovePx;
        self.alertView.frame = frame;
    }else {
        self.alertView.center = self.view.center;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
