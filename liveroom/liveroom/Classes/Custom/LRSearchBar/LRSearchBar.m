//
//  TCSearchBar.m
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/3.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSearchBar.h"
#import "UIImage+LRImageColor.h"

@interface LRSearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation LRSearchBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.returnKeyType = UIReturnKeyDone;
    UIButton *clear = [self.textField valueForKey:@"_clearButton"];
    [clear setImage:[UIImage imageNamed:@"delete_input"] forState:UIControlStateNormal];
    [self.textField setupTextField];
    [self.textField strokeWithColor:LRStrokeWhite];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.image = [UIImage imageNamed:@"search_gray"];
    self.textField.leftView = leftView;
}

#pragma mark - About TextField Setter
- (void)setPlaceholderString:(NSString *)placeholderString
{
    _placeholderString = placeholderString;
    self.textField.placeholder = _placeholderString;
}

- (void)setInputTextColor:(UIColor *)inputTextColor
{
    _inputTextColor = inputTextColor;
    self.textField.backgroundColor = _inputTextColor;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    [self.textField setValue:_placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    self.textField.layer.borderWidth = _strokeWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    self.textField.layer.borderColor = _strokeColor.CGColor;
}

- (void)setLeftView:(UIView *)leftView
{
    _leftView = leftView;
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

- (void)setPlaceholderTextFont:(CGFloat)placeholderTextFont
{
    _placeholderTextFont = placeholderTextFont;
    [self.textField setValue:[UIFont boldSystemFontOfSize:_placeholderTextFont] forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelAction:)]) {
            [self.delegate searchBarCancelAction:self];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldTextDidChange
{
    if (self.textField.text.length == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelAction:)]) {
            [self.delegate searchBarCancelAction:self];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
            [self.delegate searchBarShouldBeginEditing:self];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextDidChangeWithString:)]) {
        [self.delegate searchTextDidChangeWithString:self.textField.text];
    }
}

@end
