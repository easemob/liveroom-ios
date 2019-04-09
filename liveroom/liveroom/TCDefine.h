//
//  TCDefine.h
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/3/26.
//  Copyright © 2019 Easemob. All rights reserved.
//

#ifndef TCDefine_h
#define TCDefine_h

// frame
#define LRWindowWidth UIScreen.mainScreen.bounds.size.width
#define LRWindowHeight UIScreen.mainScreen.bounds.size.height
#define LRSafeAreaTopHeight (LRWindowWidth == 812.0 ? 88 : 64)
#define LRSafeAreaBottomHeight (LRWindowHeight == 812.0 ? 34 : 0)


#define IS_iPhoneX (\
{\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);}\
)

#define LRVIEWTOPMARGIN (IS_iPhoneX ? 22.f : 0.f)
#define LRVIEWBOTTOMMARGIN (IS_iPhoneX ? 34.f : 0.f)



// color
#define LRColor_LightGray [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0]
#define LRColor_Gray [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0]
#define LRColor_Blue [UIColor colorWithRed:45 / 255.0 green:116 / 255.0 blue:215 / 255.0 alpha:1.0]

#define LRColor_HighLightColor RGBACOLOR(255, 255, 255, 0.1)
#define LRColor_InputTextColor RGBACOLOR(255, 255, 255, 0.3)
#define LRColor_PlaceholderTextColor RGBACOLOR(255, 255, 255, 0.6)

#define LRColor_PureBlackColor [UIColor blackColor]
#define LRColor_HeightBlackColor [[UIColor whiteColor] colorWithAlphaComponent:0.05]
#define LRColor_MiddleBlackColor [[UIColor whiteColor] colorWithAlphaComponent:0.1]
#define LRColor_LowBlackColor [[UIColor whiteColor] colorWithAlphaComponent:0.5]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]



// define
#define LRLog(x)  DDLogInfo(x);

#endif /* TCDefine_h */
