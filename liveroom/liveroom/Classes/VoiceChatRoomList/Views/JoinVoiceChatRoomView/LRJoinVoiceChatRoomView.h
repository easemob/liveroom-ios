//
//  LRJoinVoiceChatRoomView.h
//  Tigercrew
//
//  Created by easemob-DN0164 on 2019/4/1.
//  Copyright © 2019年 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LRJoinVoiceChatRoomViewDelegate;
@interface LRJoinVoiceChatRoomView : UIView
@property (nonatomic, strong) NSString *voiceChatRoomName;
@property (nonatomic, strong) NSDictionary *voiceChatRoomDetails;
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<LRJoinVoiceChatRoomViewDelegate> delegate;

@end

@protocol LRJoinVoiceChatRoomViewDelegate <NSObject>

- (void)closeVoiceChatRoomView:(BOOL)isClose;

// 可根据情况另加返回参数
- (void)joinVoiceChatRoom:(BOOL)isSucess;

@end

NS_ASSUME_NONNULL_END
