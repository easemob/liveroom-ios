//
//  LRTitleView.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/4/9.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRTitleViewDelegate;
@interface LRTitleView : UIView

- (instancetype)initWithTitle:(NSString *)title;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id <LRTitleViewDelegate> delegate;

@end
@protocol LRTitleViewDelegate <NSObject>

- (void)closeViewAction;

@end
NS_ASSUME_NONNULL_END
