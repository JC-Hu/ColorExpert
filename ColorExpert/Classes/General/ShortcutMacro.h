//
//  ShortcutMacro.h
//  BaseFrame
//
//  Created by JC_Hu on 15/5/15.
//  Copyright (c) 2015年 JingchenHu. All rights reserved.
//

#ifndef BaseFrame_ShortcutMacro_h
#define BaseFrame_ShortcutMacro_h


// RGBA Color
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// String

#define NSStringFromBOOL(param) [NSString stringWithFormat:@"%d",param]
#define NSStringFromInt(param) [NSString stringWithFormat:@"%d",param]
#define NSStringFromLong(param) [NSString stringWithFormat:@"%ld",param]
#define NSStringFromLongLong(param) [NSString stringWithFormat:@"%lld",param]
#define NSStringFromDouble(param) [NSString stringWithFormat:@"%lf",param]
#define NSStringFromFloat(param) [NSString stringWithFormat:@"%f",param]


// Screen

#define kHeightOfScreen [UIScreen mainScreen].bounds.size.height
#define kWidthOfScreen [UIScreen mainScreen].bounds.size.width

#endif
