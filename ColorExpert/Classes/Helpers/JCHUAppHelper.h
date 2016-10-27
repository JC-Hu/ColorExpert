//
//  JCHUAppHelper.h
//  SHOW-iColor
//
//  Created by JC_Hu on 16/1/11.
//  Copyright © 2016年 Sixer.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHUAppHelper : NSObject
+ (UIButton *)buttonConfigToGeneralStyle:(UIButton *)button;

+ (void)lauch;

+ (BOOL)isProVersion;

+ (BOOL)isInReview;

+ (NSString *)bundleID;
+ (NSComparisonResult)compareVersionString:(NSString *)versionA with:(NSString *)versionB;

@end
