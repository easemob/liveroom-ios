//
//  LRChatViewController.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/6.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LRRoomModel;
@interface LRChatViewController : UIViewController
@property (nonatomic, weak) LRRoomModel *roomModel;
- (void)sendText:(NSString *)aText;
@end

@interface LRChatCell : UITableViewCell
@property (nonatomic, strong) UILabel *chatInfoLabel;
@end

NS_ASSUME_NONNULL_END
