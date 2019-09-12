//
//  LRCutClockView.m
//  liveroom
//
//  Created by 娜塔莎 on 2019/9/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRCutClockView.h"

@interface LRCutClockView ()
{
    int _num;  //弹框“知道了”计时器
    UIButton *_btn;
    NSTimer *_timer;
    LRTerminator clockStatus;
}
@end

@implementation LRCutClockView

- (instancetype)initWithTerminator:(LRTerminator)terminator {
    if (self = [super init]) {
        clockStatus = terminator;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    self.backgroundColor = [UIColor blackColor];
    UIView *tip = [[UIView alloc]init];
    [self addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(37);
        make.right.equalTo(self).offset(-37);
        make.height.equalTo(@250);
        make.center.equalTo(self);
    }];
    tip.backgroundColor = LRColor_HeightBlackColor;
    tip.layer.borderColor = LRColor_LowBlackColor.CGColor;
    tip.layer.borderWidth = 1.5;
    [self addSubview:tip];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [tip addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        make.left.equalTo(tip.mas_left).offset(20);
        make.top.equalTo(tip.mas_top).offset(20);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    [tip addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(5);
        make.left.equalTo(tip.mas_left).offset(20);
        make.right.equalTo(tip.mas_right).offset(-15);
        make.height.equalTo(@35);
    }];
    [title setText:@"白天发言"];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:20];
    title.adjustsFontSizeToFitWidth = YES;
    
    UILabel *content = [[UILabel alloc]init];
    [tip addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(5);
        make.left.equalTo(tip).offset(20);
        make.right.equalTo(tip.mas_right).offset(-15);
        make.bottom.lessThanOrEqualTo(tip.mas_bottom).offset(-50);
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    NSString *common;
    if(clockStatus == LRTerminator_dayTime) {
        icon.image = [UIImage imageNamed:@"sun"];
        [title setText:@"白天发言"];
        common = @"目前已切换至白天发言，所有设置将恢复默认。\n您可以点击身份图标任意切换角色体验。";
    }else{
        icon.image = [UIImage imageNamed:@"moon"];
        [title setText:@"夜晚发言"];
        common = @"目前已经切换至夜晚，只有狼人主播可以\n在夜晚发言。所有的设置将恢复默认。\n请重新点击发言按钮发言。";
    }
    content.attributedText = [[NSAttributedString alloc] initWithString:common attributes:ats];
    content.numberOfLines = 0;
    [content sizeToFit];
    content.textColor = RGBACOLOR(255, 255, 255, 1);
    content.font = [UIFont systemFontOfSize:14];
    content.adjustsFontSizeToFitWidth = YES;
    
    _btn = [[UIButton alloc]init];
    [tip addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tip.mas_bottom).offset(-20);
        make.left.right.equalTo(content);
        make.height.equalTo(@40);
    }];
    _btn.backgroundColor = [UIColor whiteColor];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)startTimer {
    [self stopTimer];
    _num = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setupBtnText) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)btnClickedAction:(UIButton *)aBtn {
    [self stopTimer];
    [self removeFromSuperview];
}

- (void)setupBtnText{
    [_btn setTitle:[NSString stringWithFormat:@"知道了  (%d)",_num] forState:UIControlStateNormal];
    if(_num < 1){
        [self stopTimer];
        [self removeFromSuperview];
        return;
    }
    _num -= 1;
}

@end
