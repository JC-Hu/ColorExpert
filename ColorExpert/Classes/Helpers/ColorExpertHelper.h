//
//  ColorExpertHelper.h
//  ColorExpert
//
//  Created by JC_Hu on 16/4/3.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    ColorExpertProductTypeNormal,
    ColorExpertProductTypeR2H,
    ColorExpertProductTypeH2R,
    ColorExpertProductTypeHSB,
    ColorExpertProductTypeCMYK
} ColorExpertProductType;

typedef enum : NSUInteger {
    ColorFormRGB,
    ColorFormHex,
    ColorFormHSB,
    ColorFormCMYK
} ColorFormType;

#define APP_GROUP_TEMP_CONTAINER_ID @"group.temp.com.jchu.ColorExpert"

@interface ColorExpertHelper : NSObject

+ (NSString *)UMAppKey;
+ (NSString *)GoogleAdID;
+ (ColorExpertProductType)productType;
+ (NSString *)appID;
@end
