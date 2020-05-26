//
//  LRCutClockView.h
//  liveroom
//
//  Created by 娜塔莎 on 2019/9/11.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRCutClockView : UIView
- (void)startTimer;
- (void)stopTimer;
- (instancetype)initWithTerminator:(LRTerminator)terminator;
@end

NS_ASSUME_NONNULL_END
