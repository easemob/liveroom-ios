//
//  LRLoginHintView.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/3/27.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LRLoginHintViewDelegate;
@interface LRLoginHintView : UIView

@property (nonatomic, weak) id<LRLoginHintViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;


@end

@protocol LRLoginHintViewDelegate <NSObject>

- (void)loginWithRegistStatus:(BOOL)isSucess;

@end

NS_ASSUME_NONNULL_END
