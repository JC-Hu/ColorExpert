//
//  BaseHeader.h
//  ColorExpert
//
//  Created by JC_Hu on 16/5/18.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#ifndef BaseHeader_h
#define BaseHeader_h


#import "Macro.h"
#import "ShortcutMacro.h"
#import "UIView+Shortcut.h"
#import "ColorExpertHelper.h"
#import "UIColor+JCHUColorInfo.h"
#import "UIColor+Separate.h"
#import "UIColor+HEX.h"
#import "NSString+Judge.h"
#import "JCHUAppHelper.h"




#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif




#endif /* BaseHeader_h */
