//
//  LRVolumeView.h
//  testView
//
//  Created by 杜洁鹏 on 2019/4/9.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRVolumeView : UIView
@property (nonatomic) CGFloat progress;

- (void)startSpeakAnimationImage;

- (void)endSpeakAnimationImage;

@end

NS_ASSUME_NONNULL_END
