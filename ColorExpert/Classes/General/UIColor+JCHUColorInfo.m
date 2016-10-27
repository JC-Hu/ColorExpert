//
//  UIColor+JCHUColorInfo.m
//  playStoryBoard
//
//  Created by JC_Hu on 14/10/27.
//  Copyright (c) 2014年 Sixer.inc. All rights reserved.
//

#import "UIColor+JCHUColorInfo.h"
#import "ShortcutMacro.h"
#import "NSString+Judge.h"
#import "UIColor+HEX.h"

@implementation UIColor (JCHUColorInfo)

- (ColorRGBInfo *)RGBInfo
{
    ColorRGBInfo *rgbInfo = [ColorRGBInfo new];
    CGFloat r, g, b;
    
    [self getRed:&r green:&g blue:&b alpha:nil];
    
    rgbInfo.red = [NSString stringWithFormat:@"%d", (int)(r*255+.5)];
    rgbInfo.green = [NSString stringWithFormat:@"%d", (int)(g*255+.5)];
    rgbInfo.blue = [NSString stringWithFormat:@"%d", (int)(b*255+.5)];
    return rgbInfo;
}


- (ColorHexInfo *)HexInfo
{
    ColorHexInfo *hexInfo = [ColorHexInfo new];
    CGFloat r, g, b;
    
    [self getRed:&r green:&g blue:&b alpha:nil];
    
    int rInt = (int)(r*255+.5);
    int gInt = (int)(g*255+.5);
    int bInt = (int)(b*255+.5);
    
    NSString *rStr = [NSString stringWithFormat:@"%02x", rInt];
    NSString *gStr = [NSString stringWithFormat:@"%02x", gInt];
    NSString *bStr = [NSString stringWithFormat:@"%02x", bInt];

    hexInfo.hex = [[NSString stringWithFormat:@"%@%@%@", rStr, gStr, bStr] uppercaseString];
    
    return hexInfo;
}

- (ColorCMYKInfo *)CMYKInfo
{
    ColorCMYKInfo *cmykInfo = [ColorCMYKInfo new];
    CGFloat r, g, b;
    CGFloat c, m, y, k, w;
    
    [self getRed:&r green:&g blue:&b alpha:nil];
    
    if (r == 0 && g == 0 && b == 0) {
        c = 0;
        m = 0;
        y = 0;
        k = 1;
    } else {
        w = MAX(r, g);
        w = MAX(w, b);
        
        c = (w - r) / w;
        m = (w - g) / w;
        y = (w - b) / w;
        k = 1.0 - w;
    }
    
    cmykInfo.cInfo = [NSString stringWithFormat:@"%d", (int)(c*100+.5)];
    cmykInfo.mInfo = [NSString stringWithFormat:@"%d", (int)(m*100+.5)];
    cmykInfo.yInfo = [NSString stringWithFormat:@"%d", (int)(y*100+.5)];
    cmykInfo.kInfo = [NSString stringWithFormat:@"%d", (int)(k*100+.5)];
    
    
    return cmykInfo;
}



- (ColorHSBInfo *)HSBInfo
{
    CGFloat h, s, b;
    
    [self getHue:&h saturation:&s brightness:&b alpha:nil];
    
    
    ColorHSBInfo *hsbInfo = [ColorHSBInfo new];
    
    hsbInfo.hInfo = [NSString stringWithFormat:@"%d", (int)(h*360+.5)];
    hsbInfo.sInfo = [NSString stringWithFormat:@"%d", (int)(s*100+.5)];
    hsbInfo.bInfo = [NSString stringWithFormat:@"%d", (int)(b*100+.5)];
    
    
    return hsbInfo;
    
}

+ (UIColor *)colorWithC:(NSInteger)c M:(NSInteger)m Y:(NSInteger)y K:(NSInteger)k
{
//    NSInteger r =(int)(1.0-c/8.0)*(1.0-k/8.0)*255.0 +0.5;
//    NSInteger g =(int)(1.0 - m/8.0) * (1.0 - k/8.0) * 255.0+0.5;
//    NSInteger b =(int)(1.0 - y/8.0) * (1.0 - k/8.0) * 255.0+0.5;

    NSInteger r = 255*(100-c)*(100-k)/10000;
    NSInteger g = 255*(100-m)*(100-k)/10000;
    NSInteger b = 255*(100-y)*(100-k)/10000;

    return RGBACOLOR(r, g, b, 1);
}

+ (UIColor *)colorWithString:(NSString *)string formType:(ColorFormType)formType
{
    
    UIColor *color = nil;
    switch (formType) {
        case ColorFormRGB:{
            
            NSString *number =@"0123456789";
            NSCharacterSet * set =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
            
            NSArray *array = [string componentsSeparatedByCharactersInSet:set];
            
            NSString *str1 = nil; NSString *str2 = nil; NSString *str3 = nil;
            
            for (NSString *str in array) {
                if (str.length && [str isNumberStr]) {
                    if (!str1) {
                        str1 = str;
                        continue;
                    }
                    
                    if (!str2) {
                        str2 = str;
                        continue;
                    }
                    
                    if (!str3) {
                        str3 = str;
                        break;
                    }
                    
                }
            }
            
            if (!str3) {
                color = nil;
            } else {
                color = RGBACOLOR(str1.integerValue, str2.integerValue, str3.integerValue, 1);
            }
            break;
        }
        case ColorFormHex:{
            NSString *hex =@"0123456789abcdefABCDEF";
            NSCharacterSet * set =[[NSCharacterSet characterSetWithCharactersInString:hex]invertedSet];
            NSString *strHEX = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
            if (strHEX.length!=6) {
                color = nil;
            } else {
                color = [UIColor colorWithHexString:strHEX];
            }
            break;
        }
        case ColorFormHSB:{
            NSString *number =@"0123456789";
            NSCharacterSet * set =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
            
            NSArray *array = [string componentsSeparatedByCharactersInSet:set];
            
            NSString *str1 = nil; NSString *str2 = nil; NSString *str3 = nil;
            
            for (NSString *str in array) {
                if (str.length && [str isNumberStr]) {
                    if (!str1) {
                        str1 = str;
                        continue;
                    }
                    
                    if (!str2) {
                        str2 = str;
                        continue;
                    }
                    
                    if (!str3) {
                        str3 = str;
                        break;
                    }
                    
                }
            }
            if (!str3) {
                color = nil;
            } else {
                color = [UIColor colorWithHue:str1.integerValue/360.0 saturation:str2.integerValue/100.0 brightness:str3.integerValue/100.0 alpha:1];
            }
            break;
        }
        case ColorFormCMYK:{
            NSString *number =@"0123456789";
            NSCharacterSet * set =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
            
            NSArray *array = [string componentsSeparatedByCharactersInSet:set];
            
            NSString *str1 = nil; NSString *str2 = nil; NSString *str3 = nil; NSString *str4 = nil;
            
            for (NSString *str in array) {
                if (str.length && [str isNumberStr]) {
                    if (!str1) {
                        str1 = str;
                        continue;
                    }
                    if (!str2) {
                        str2 = str;
                        continue;
                    }
                    if (!str3) {
                        str3 = str;
                        continue;
                    }
                    if (!str4) {
                        str4 = str;
                        break;
                    }
                }
            }
            
            if (!str4) {
                color = nil;
            } else {
                color = [UIColor colorWithC:str1.integerValue M:str2.integerValue Y:str3.integerValue K:str4.integerValue];
            }
            break;
        }
        default:
            break;
    }
    
    return color;
}



#pragma mark -

- (NSString *)stringForColorType:(ColorFormType)type
{
    NSString *text = nil;
    
    if (type == ColorFormRGB) {
        text = [NSString stringWithFormat:@"%@,%@,%@", self.RGBInfo.red, self.RGBInfo.green, self.RGBInfo.blue];
    } else if (type == ColorFormHex){
        text = self.HexInfo.hex;
    } else if (type == ColorFormHSB){
        text = [NSString stringWithFormat:@"%@,%@,%@", self.HSBInfo.hInfo, self.HSBInfo.sInfo, self.HSBInfo.bInfo];
    } else if (type == ColorFormCMYK) {
        text = [NSString stringWithFormat:@"%@,%@,%@,%@", self.CMYKInfo.cInfo, self.CMYKInfo.mInfo, self.CMYKInfo.yInfo, self.CMYKInfo.kInfo];
        
    }
    
    return text;
}


@end
