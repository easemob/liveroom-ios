//
//  LRSpeakerWerewolfkilledCell.h
//  liveroom
//
//  Created by easemob-DN0164 on 2019/8/22.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import "LRSpeakerCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSpeakerPentakillCell : LRSpeakerCell

@property (nonatomic, strong) NSString *identity;//全局单例狼人杀模式身份标识

- (void)updateIdentity;//显示/隐藏 狼人杀模式身份图标
+ (LRSpeakerPentakillCell *)sharedInstance;//生成单例
- (void)destoryInstance;//销毁单例

@end

NS_ASSUME_NONNULL_END
