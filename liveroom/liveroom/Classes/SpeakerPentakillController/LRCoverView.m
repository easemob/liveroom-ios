//
//  LRCoverViewController.m
//  liveroom
//
//  Created by 娜塔莎 on 2019/9/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRCoverView.h"

@interface LRCoverView(){
    NSTimer *_timers;
    UILabel *_title;
    NSMutableString *_omit;
}
@end

@implementation LRCoverView

- (void)setupNightCoverUI:(UIView *)werewolfView {
    
    UIImageView *icon = [[UIImageView alloc]init];
    [werewolfView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        make.left.equalTo(werewolfView.mas_left).offset(15);
        make.top.equalTo(werewolfView.mas_top).offset(20);
    }];
    icon.image = [UIImage imageNamed:@"werewolf"];
    
    _title = [[UILabel alloc]init];
    [werewolfView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(5);
        make.left.equalTo(werewolfView.mas_left).offset(15);
        make.right.equalTo(werewolfView.mas_right).offset(-15);
        make.height.equalTo(@35);
    }];
    [_title setText:@"夜晚狼人正在发言..."];
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont systemFontOfSize:20];
    _title.adjustsFontSizeToFitWidth = YES;
    
    UILabel *content = [[UILabel alloc]init];
    [werewolfView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_title.mas_bottom).offset(5);
        make.left.equalTo(werewolfView).offset(15);
        make.right.equalTo(werewolfView.mas_right).offset(-15);
        make.bottom.lessThanOrEqualTo(werewolfView.mas_bottom);
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    NSString *common = @"目前正在夜晚发言，只有狼人主播可以在夜晚发言。\n请等待管理员切换成白天模式，恢复全员自由发言。";
    content.attributedText = [[NSAttributedString alloc] initWithString:common attributes:ats];
    content.numberOfLines = 0;
    [content sizeToFit];
    content.textColor = RGBACOLOR(255, 255, 255, 1);
    content.font = [UIFont systemFontOfSize:14];
    content.adjustsFontSizeToFitWidth = YES;
    _omit = [[NSMutableString alloc]init];
    [_omit setString:@""];
}

- (void)startTimers {
    [self stopTimers];
    _timers = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(setupTitleText) userInfo:nil repeats:YES];
    [_timers fire];
}

- (void)stopTimers {
    if (_timers) {
        [_timers invalidate];
        _timers = nil;
        [_omit setString:@""];
    }
}

- (void)setupTitleText{
    [_omit appendString:@"."];
    NSLog(@"\n omit:    %@",_omit);
    [_title setText:[NSString stringWithFormat:@"夜晚狼人正在发言%@",_omit]];
    if([_omit isEqualToString:@"..."]){
        [_omit setString:@""];
    }
}

@end
