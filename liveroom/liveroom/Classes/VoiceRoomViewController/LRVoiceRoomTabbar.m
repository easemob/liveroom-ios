//
//  LRVoiceRoomTabbar.m
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/6.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRVoiceRoomTabbar.h"
#import "Headers.h"

#define kPadding 12

@interface LRVoiceRoomTabbar () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *inputTextView;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@end

@implementation LRVoiceRoomTabbar

- (instancetype)init {
    if (self = [super init]) {
        [self _registerNotifiers];
        [self _setupSubViews];
    }
    return self;
}

#pragma mark - notifiers
- (void)_registerNotifiers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)aNoti {
    NSDictionary *userInfo = aNoti.userInfo;
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewHeightDidChanged:duration:show:)]) {
        [_delegate inputViewHeightDidChanged:keyboardEndFrame.origin.y duration:duration show:YES];
    }
}

- (void)keyboardWillHidden:(NSNotification *)aNoti {
    NSDictionary *userInfo = aNoti.userInfo;
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewHeightDidChanged:duration:show:)]) {
        [_delegate inputViewHeightDidChanged:keyboardEndFrame.origin.y duration:duration show:NO];
    }
}

#pragma mark - subviews
- (void)_setupSubViews {
    [self addSubview:self.inputTextView];
    [self addSubview:self.likeBtn];
    [self addSubview:self.giftBtn];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kPadding);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.likeBtn.mas_left).offset(-kPadding);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextView);
        make.bottom.equalTo(self.inputTextView);
        make.right.equalTo(self.giftBtn.mas_left).offset(-kPadding);
        make.width.equalTo(self.likeBtn.mas_height);
    }];

    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn);
        make.bottom.equalTo(self.likeBtn);
        make.right.equalTo(self);
        make.width.equalTo(self.giftBtn.mas_height);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendAction:)]) {
            [_delegate sendAction:textField.text];
            textField.text = @"";
        }
    }
    return YES;
}

#pragma mark - actions
- (void)likeBtnAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(likeAction)]) {
        [_delegate likeAction];
    }
}

- (void)giftBtnAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(giftAction)]) {
        [_delegate giftAction];
    }
}


#pragma mark - getter
- (UITextField *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextField alloc] init];
        [_inputTextView strokeWithColor:LRStrokeLowBlack];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = LRColor_HeightBlackColor;
        _inputTextView.placeholder = @"say me to your heart";
        [_inputTextView setupTextField];
    }
    return _inputTextView;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.backgroundColor = [UIColor whiteColor];
        [_likeBtn setImage:[UIImage imageNamed:@"like"]  forState:UIControlStateNormal];
        [_likeBtn addTarget:self
                     action:@selector(likeBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftBtn.backgroundColor = [UIColor whiteColor];
        [_giftBtn setImage:[UIImage imageNamed:@"gift"]  forState:UIControlStateNormal];
        [_giftBtn addTarget:self
                     action:@selector(giftBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}

@end
