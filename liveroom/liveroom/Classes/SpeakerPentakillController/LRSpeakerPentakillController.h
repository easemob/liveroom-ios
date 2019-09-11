//
//  LRSpeakerWerewolfkilledController.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/22.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakViewController.h"
#import "LRCoverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSpeakerPentakillController : LRSpeakViewController
@property (nonatomic, strong) UIView *schedule;   //狼人杀模式下切换白天黑夜
@property (nonatomic, strong) LRCoverView *coverView;//夜晚遮掩UI
@end

NS_ASSUME_NONNULL_END
