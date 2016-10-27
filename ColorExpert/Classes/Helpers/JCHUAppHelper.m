//
//  JCHUAppHelper.m
//  SHOW-iColor
//
//  Created by JC_Hu on 16/1/11.
//  Copyright © 2016年 Sixer.inc. All rights reserved.
//

#import "JCHUAppHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImage+Color.h"
#import "NSDate+Utilities.h"

@implementation JCHUAppHelper



+ (void)lauch
{
    [self requestStoreVersion];
    
    
    [self requestCloudConfig];
    
    [ColorExpertHelper appID];
}

+ (UIButton *)buttonConfigToGeneralStyle:(UIButton *)button
{
    
    [button setTitleColor:kColorOfPurple forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:kColorOfPurple] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setBackgroundImage:nil forState:UIControlStateDisabled];
    
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    
    
    return button;
}

+ (BOOL)isProVersion
{
    if ([ColorExpertHelper productType] == ColorExpertProductTypeNormal) {
        return YES;
    } else {
        return NO;
    }
    
}

+ (BOOL)isInReview
{
    // 云端控制的在审版本
//    NSString *versionInReview = [[NSUserDefaults standardUserDefaults] objectForKey:CLOUD_VERSION_IN_REVIEW];
//    
//    if (versionInReview.length) {
//        
//        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//
//        if ([versionInReview isEqualToString:currentVersion]) {
//            return YES;
//        }
//        
//        return NO;
//    }
    
    
    // 通过商店版本号判断
    NSString *storeVersion = [[NSUserDefaults standardUserDefaults] objectForKey:STORE_VERSION_KEY];
    
    if (storeVersion.length) {
        
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if ([self compareVersionString:currentVersion with:storeVersion] == NSOrderedDescending) {
            return YES;
        }
        
        return NO;
    }
    
    
    // 通过时间判断
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *reviewDate = [formatter dateFromString:@"2016-3-22"];
    NSInteger days = [date daysAfterDate:reviewDate];
    if (days <= 0) {
        return YES;
    }
    return NO;
}


+ (NSString *)bundleID
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleID = [info objectForKey:(__bridge id)kCFBundleIdentifierKey];
    
    return bundleID;
}


#pragma mark -
+ (NSComparisonResult)compareVersionString:(NSString *)versionA with:(NSString *)versionB
{
    NSComparisonResult result = NSOrderedSame;
    
    NSArray *arrayA = [versionA componentsSeparatedByString:@"."];
    NSArray *arrayB = [versionB componentsSeparatedByString:@"."];
    
    int i = 0;
    while (1) {
        
        if (arrayA.count - 1 < i) {
            
            if (arrayA.count == arrayB.count) {
                result = NSOrderedSame;
                break;
            }
            
            result = NSOrderedAscending;
            break;
        }
        
        if (arrayB.count - 1 < i) {
            
            result = NSOrderedDescending;
            break;
        }
        
        
        NSString *strA = arrayA[i];
        NSString *strB = arrayB[i];
        
        NSComparisonResult res = [@([strA integerValue]) compare:@([strB integerValue])];
        
        if (res == NSOrderedAscending) {
            
            result = res;
            break;
            
        } else if (res == NSOrderedDescending) {
            
            result = res;
            break;
            
        } else {
            
        }
        
        i++;
    }
    
    
    return result;
}


#pragma mark -
+ (void)requestStoreVersion
{
    
    __block NSString *latestStoreVersion = [NSString string];
    NSString *checkVersionURL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APP_ID];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    
    [mgr POST:checkVersionURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *recvDict = responseObject;
        NSArray *infoArray = [recvDict objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            latestStoreVersion = [releaseInfo objectForKey:@"version"];
            NSLog(@"latestStoreVersion = %@", latestStoreVersion);
            
            [[NSUserDefaults standardUserDefaults] setObject:latestStoreVersion forKey:STORE_VERSION_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            return ;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestStoreVersion];
        });
        
    }];
    
}



+ (void)requestCloudConfig
{
    [self requestRateAndRemoveAd];
    
}

+ (void)requestRateAndRemoveAd
{
    
    
//    [[JCHUCloudHelper shareInstance] requestConfig:CloudConfigRateAndRemoveAd WithBlock:^(id result, NSString *error) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:@([result boolValue]) forKey:CLOUD_RATE_AND_REMOVE_AD];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
//    
//    [[JCHUCloudHelper shareInstance] requestConfig:CloudConfigAdUnitID WithBlock:^(id result, NSString *error) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:result  forKey:CLOUD_AD_UNIT_ID];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
//    
//    [[JCHUCloudHelper shareInstance] requestConfig:CloudConfigAdShouldShow WithBlock:^(id result, NSString *error) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:@([result boolValue]) forKey:CLOUD_AD_SHOULD_SHOW];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
//    
//    [[JCHUCloudHelper shareInstance] requestConfig:CloudConfigVersionInReview WithBlock:^(id result, NSString *error) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:result forKey:CLOUD_VERSION_IN_REVIEW];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
    
    
}


@end
