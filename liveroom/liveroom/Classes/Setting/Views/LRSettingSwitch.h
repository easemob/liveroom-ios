//
//  LRSettingSwitch.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LRSettingSwitchDelegate;
@interface LRSettingSwitch : UIView

@property (nonatomic, weak) id <LRSettingSwitchDelegate> delegate;
@property (nonatomic, assign) BOOL isOn;

-(id)initWithFrame:(CGRect)frame;
- (void)setOn:(BOOL)isOn animated:(BOOL)animated;
//- (void)setupTagBack:(float)width height:(float)height;  //免密创建房间UI设置
@end

@protocol LRSettingSwitchDelegate <NSObject>

- (void)settingSwitchWithValueChanged:(LRSettingSwitch *)aSwitch;

@end

NS_ASSUME_NONNULL_END
