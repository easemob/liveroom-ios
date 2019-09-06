//
//  LRCoverViewController.m
//  liveroom
//
//  Created by 娜塔莎 on 2019/9/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "LRCoverViewController.h"

@interface LRCoverViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableString *omit;

@end

@implementation LRCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_omit setString:@""];
    // Do any additional setup after loading the view.
}

- (void)setupNightCoverUI:(UIView *)_werewolfView {
    
    UIImageView *icon = [[UIImageView alloc]init];
    [_werewolfView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        make.left.equalTo(_werewolfView.mas_left).offset(15);
        make.top.equalTo(_werewolfView.mas_top).offset(20);
    }];
    icon.image = [UIImage imageNamed:@"werewolf"];
    
    UILabel *title = [[UILabel alloc]init];
    [_werewolfView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(5);
        make.left.equalTo(_werewolfView.mas_left).offset(15);
        make.right.equalTo(_werewolfView.mas_right).offset(-15);
        make.height.equalTo(@35);
    }];
    [title setText:@"夜晚狼人正在发言..."];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:20];
    title.adjustsFontSizeToFitWidth = YES;
    
    UILabel *content = [[UILabel alloc]init];
    [_werewolfView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(5);
        make.left.equalTo(_werewolfView).offset(15);
        make.right.equalTo(_werewolfView.mas_right).offset(-15);
        make.height.equalTo(@130);
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    NSString *common = @"目前正在夜晚发言，只有狼人主播可以在夜晚发言。\n请等待管理员切换成白天模式，恢复全员自由发言。\n请等待管理员切换至白天。\n\n\n\n\n\n";
    content.attributedText = [[NSAttributedString alloc] initWithString:common attributes:ats];
    content.numberOfLines = 0;
    [content sizeToFit];
    content.textColor = RGBACOLOR(255, 255, 255, 1);
    content.font = [UIFont systemFontOfSize:14];
    content.adjustsFontSizeToFitWidth = YES;

}


- (NSMutableString *)omit {
    if(!_omit){
        _omit = [[NSMutableString alloc]init];
    }
    return _omit;
}

- (void)dealloc{
    
}
@end
