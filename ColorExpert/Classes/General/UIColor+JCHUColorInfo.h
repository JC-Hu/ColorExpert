//
//  UIColor+JCHUColorInfo.h
//  playStoryBoard
//
//  Created by JC_Hu on 14/10/27.
//  Copyright (c) 2014年 Sixer.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorCMYKInfo.h"
#import "ColorHexInfo.h"
#import "ColorRGBInfo.h"
#import "ColorHSBInfo.h"
#import "ColorExpertHelper.h"

@interface UIColor (JCHUColorInfo)

// 得到颜色信息
- (ColorRGBInfo *)RGBInfo;
- (ColorHexInfo *)HexInfo;
- (ColorCMYKInfo *)CMYKInfo;
- (ColorHSBInfo *)HSBInfo;

+ (UIColor *)colorWithC:(NSInteger)c M:(NSInteger)m Y:(NSInteger)y K:(NSInteger)k;

+ (UIColor *)colorWithString:(NSString *)string formType:(ColorFormType)formType;

#pragma mark -

- (NSString *)stringForColorType:(ColorFormType)type;



@end
