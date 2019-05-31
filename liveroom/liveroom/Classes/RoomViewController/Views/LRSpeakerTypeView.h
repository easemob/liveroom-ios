//
//  LRSpeakerTypeView.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTypes.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LRSpeakerTypeViewDelegate <NSObject>
- (void)switchBtnClicked;
- (void)speakerTypeWithSelect:(LRRoomType)type;
@end

@interface LRSpeakerTypeView : UIView
@property (nonatomic) LRRoomType type;
@property (nonatomic) id<LRSpeakerTypeViewDelegate> delegate;

- (void)setupEnable:(BOOL)isEnable;
@end

NS_ASSUME_NONNULL_END
