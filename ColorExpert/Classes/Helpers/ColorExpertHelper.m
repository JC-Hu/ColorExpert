//
//  ColorExpertHelper.m
//  ColorExpert
//
//  Created by JC_Hu on 16/4/3.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import "ColorExpertHelper.h"

@implementation ColorExpertHelper

+ (NSString *)UMAppKey
{
    
    switch ([self productType]) {
            
        case ColorExpertProductTypeNormal:{
            
            return @"57013ce3e0f55a80c1003a4a";

            break;
        }
        case ColorExpertProductTypeR2H:{
            
            return @"57013d2de0f55a5c360008b2";

            break;
        }
        case ColorExpertProductTypeH2R:{
            
            return @"57013d64e0f55acc89001a53";

            break;
        }
        case ColorExpertProductTypeCMYK:{
            
            return @"57013d8ce0f55a344800194e";

            break;
        }
        case ColorExpertProductTypeHSB:{
            
            return @"57013dad67e58ed296000f3c";

            break;
        }
        default:
            return @"57013ce3e0f55a80c1003a4a";

            break;
    }
    
    
    
    // R2H 57013d2de0f55a5c360008b2
    // H2R 57013d64e0f55acc89001a53
    // CMYK 57013d8ce0f55a344800194e
    // HSB 57013dad67e58ed296000f3c
}

+ (NSString *)GoogleAdID
{
    
    switch ([self productType]) {
            
        case ColorExpertProductTypeNormal:{
            
            return @"ca-app-pub-5587951421072030/9709573108";
            
            break;
        }
        case ColorExpertProductTypeR2H:{
            
            return @"ca-app-pub-5587951421072030/5902678702";
            
            break;
        }
        case ColorExpertProductTypeH2R:{
            
            return @"ca-app-pub-5587951421072030/7379411905";
            
            break;
        }
        case ColorExpertProductTypeCMYK:{
            
            return @"ca-app-pub-5587951421072030/1332878304";
            
            break;
        }
        case ColorExpertProductTypeHSB:{
            
            return @"ca-app-pub-5587951421072030/2809611502";
            
            break;
        }
        default:
            return @"a-app-pub-5587951421072030/9709573108";
            
            break;
    }
    
    
    
    // R2H 57013d2de0f55a5c360008b2
    // H2R 57013d64e0f55acc89001a53
    // CMYK 57013d8ce0f55a344800194e
    // HSB 57013dad67e58ed296000f3c
}

+ (NSString *)appID
{
    switch ([self productType]) {
            
        case ColorExpertProductTypeNormal:{
            
            return @"1090866804";
            
            break;
        }
        case ColorExpertProductTypeR2H:{
            
            return @"1099610543";
            
            break;
        }
        case ColorExpertProductTypeH2R:{
            
            return @"1099610548";
            
            break;
        }
        case ColorExpertProductTypeCMYK:{
            
            return @"1099610513";
            
            break;
        }
        case ColorExpertProductTypeHSB:{
            
            return @"1099610518";
            
            break;
        }
        default:
            return @"1090866804";
            
            break;
    }
    
}



+ (ColorExpertProductType)productType
{
#ifdef COLOR_EXPERT_PRODUCT_TYPE
    return COLOR_EXPERT_PRODUCT_TYPE;
#else
    return ColorExpertProductTypeNormal;
#endif
}

@end
