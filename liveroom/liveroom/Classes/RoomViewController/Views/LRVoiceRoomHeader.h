//
//  LRVoiceRoomHeader.h
//  liveroom
//
//  Created by 杜洁鹏 on 2019/4/3.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRVoiceRoomHeaderItem : UIButton
+ (LRVoiceRoomHeaderItem *)itemWithImage:(UIImage *)aImg
                                  target:(id __nullable)aTarget
                                  action:(SEL __nullable)aAction;

+ (LRVoiceRoomHeaderItem *)itemWithImageName:(NSString *)aImgName
                                  target:(id __nullable)aTarget
                                  action:(SEL __nullable)aAction;
@end

@interface LRVoiceRoomHeader : UIView
@property (nonatomic, strong) NSArray *actionList;
- (instancetype)initWithTitle:(NSString *)aTitle info:(NSString *)aInfo;
@end

NS_ASSUME_NONNULL_END
