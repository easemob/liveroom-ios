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
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end

@protocol LRSettingSwitchDelegate <NSObject>

- (void)settingSwitchWithValueChanged:(LRSettingSwitch *)aSwitch;

@end

NS_ASSUME_NONNULL_END
