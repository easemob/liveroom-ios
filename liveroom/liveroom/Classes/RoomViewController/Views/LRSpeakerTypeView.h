//
//  LRSpeakerTypeView.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/10.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LRSpeakerType_Host,             // 主持模式
    LRSpeakerType_Monopoly,         // 抢麦模式
    LRSpeakerType_Communication     // 自由模式
} LRSpeakerType;

@protocol LRSpeakerTypeViewDelegate <NSObject>
- (void)switchBtnClicked;
- (void)speakerTypeWithSelect:(LRSpeakerType)type;
@end

@interface LRSpeakerTypeView : UIView
@property (nonatomic) LRSpeakerType type;
@property (nonatomic) id<LRSpeakerTypeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
