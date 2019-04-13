//
//  LRTabBarView.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LRTabBar;
@protocol LRTabBarDelegate;

//typedef void(^TabBarBlock)(LRTabBar *tabBar,LRItemType tag);
@interface LRTabBar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <LRTabBarDelegate> delegate;

@end

@protocol LRTabBarDelegate <NSObject>

- (void)tabBar:(LRTabBar *)tabBar clickViewAction:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
