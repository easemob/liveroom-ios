//
//  LRCoverViewController.h
//  liveroom
//
//  Created by 娜塔莎 on 2019/9/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRCoverView : UIView
- (void)startTimers;
- (void)stopTimers;
- (void)setupNightCoverUI:(UIView *)_werewolfView;
@end

NS_ASSUME_NONNULL_END
