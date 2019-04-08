//
//  LRTabBarView.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/7.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LRItemType) {
    LRItemTypeLeft = 100,
    LRItemTypeMiddle,
    LRItemTypeRight
};

@class LRTabBar;
@protocol LRTabBarDelegate;

//typedef void(^TabBarBlock)(LRTabBar *tabBar,LRItemType tag);
@interface LRTabBar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <LRTabBarDelegate> delegate;

// 上一次点击的item
@property (nonatomic, strong) UIView *lastItem;

@end

@protocol LRTabBarDelegate <NSObject>

//再将tag类型换为枚举类型
- (void)tabBar:(LRTabBar *)tabBar clickViewAction:(LRItemType)type;

@end



NS_ASSUME_NONNULL_END
