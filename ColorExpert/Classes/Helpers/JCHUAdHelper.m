//
//  JCHUAdHelper.m
//  SHOW-iColor
//
//  Created by JC_Hu on 16/1/29.
//  Copyright © 2016年 Sixer.inc. All rights reserved.
//

#import "JCHUAdHelper.h"
#import "RealReachability.h"
#import "NSDate+Utilities.h"
#import "JCHUAppHelper.h"

@import GoogleMobileAds;

NSString *const AdRemovedNotificationName = @"AdRemovedNotificationName";

@interface JCHUAdHelper ()<GADInterstitialDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) BOOL showAd;

@property (nonatomic, strong) UIAlertView *processAlert;

@property (nonatomic, assign) NSUInteger retryCount;

@end

@implementation JCHUAdHelper

#pragma mark - 创建单例方法
static JCHUAdHelper *instance = nil;

+ (instancetype)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
        
        [instance createAndLoadInterstitial];
        
        instance.showAd = YES;
        if ([JCHUAppHelper isProVersion]) {
            // 专业版不显示广告
            instance.showAd = NO;
        }
    }
    return instance;
}

- (void)prepare
{
    
}

- (void)showInterstitialAd
{
    if (![self shouldShowAd]) {
        return;
    }
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_AD_SHOW_TIME_KEY];
    if (obj) {
        NSTimeInterval interval = [obj doubleValue];
        
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSTimeInterval ti = [[NSDate date] timeIntervalSinceDate:lastDate];
        CGFloat minutes = (ti / 60.0);
        
        CGFloat minInterval = 1.2;

        if (minutes < minInterval) {
            return;
        }
    }
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:vc];
        [[NSUserDefaults standardUserDefaults] setObject:@([[NSDate date] timeIntervalSince1970])  forKey:LAST_AD_SHOW_TIME_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self createAndLoadInterstitial];
    }

}

- (void)createAndLoadInterstitial {
//#ifdef FREE_VERSION
//    NSString *ID = @"ca-app-pub-5587951421072030/7350257908";
//#else
//#endif
    NSString *ID = [ColorExpertHelper GoogleAdID];
    
    NSString *cloudAdID = [[NSUserDefaults standardUserDefaults] objectForKey:CLOUD_AD_UNIT_ID];
    
    if (cloudAdID.length) {
        ID = cloudAdID;
    }
    
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ID];
    self.interstitial.delegate = self;
    
    [self requestAd];
}

- (void)requestAd
{
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"3a1a5b74a1afa6711c1d5f4535820593"];
    [self.interstitial loadRequest:request];
}


#pragma mark GADInterstitialDelegate implementation

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
//    if (![self shouldShowAd]) {
//        return;
//    }
//    
//    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//
//    [self.interstitial presentFromRootViewController:vc];
}

#pragma mark - 控制广告显隐相关
/// 是否应该显示广告
- (BOOL)shouldShowAd
{
    if ([self haveRemovedAd]) {
        return NO;
    }
    
    if ([ColorExpertHelper productType] == ColorExpertProductTypeNormal) {
        // 专业版审核时假广告
        if ([JCHUAppHelper isInReview]) {
            return YES;
        }
    }
    
    return self.showAd;
}

/// 是否已去除广告
- (BOOL)haveRemovedAd
{
    BOOL removed = [[NSUserDefaults standardUserDefaults] boolForKey:REMOVE_AD_KEY];
    
    return removed;
}


/// 是否开启好评去广告
- (BOOL)isRateAndRemoveAdOn
{
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:CLOUD_RATE_AND_REMOVE_AD];
    
    return isOn;
}

/// 去除广告
- (void)removeAd
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:REMOVE_AD_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AdRemovedNotificationName object:nil];
}


#pragma mark - 好评去广告流程
- (void)processRateAndRemoveAd
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate and Remove Ad" message:@"Confirm and remove ad" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",@"Rate", nil];
    
    [alert show];
    
}

- (void)fakeConfirm
{
    // 判断网络
    // 提示
    [self.processAlert show];
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable) {
        // 无网络
        [self.processAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Connection" message:@"Please check network connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
        
        [alert show];
        
        return;
    }
    
    // 假延迟
    CGFloat delay = (arc4random()%40 + 20)/10.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (status == RealStatusNotReachable) {
            // 无网络
            [self.processAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Connection" message:@"Please check network connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
            
            [alert show];
            
        } else {
            
            
            
            [self.processAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            if (arc4random()%4 == 1 && self.retryCount < 3) {
                // 五分之一概率出错
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirming Fail" message:@"Please try again later" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
                
                [alert show];
                
                self.retryCount++;
            } else {
                // 验证成功
                
                [self removeAd];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirming Success" message:@"Ad is removed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alert show];
                
            }
            
        }
    });
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.processAlert) {
        return;
    }
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Try Again"]) {
        // 重试
        [self fakeConfirm];
        
    } else if ([title isEqualToString:@"Confirm"]) {
        
        [self fakeConfirm];
        
    } else if ([title isEqualToString:@"Rate"]) {
        
        // 去广告
        NSString *str = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1080129732&pageNumber=0&type=Purple+Software&pt=117317585&ct=removeAd&mt=8";// 评论页+统计
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        [self processRateAndRemoveAd];
    }
}

#pragma mark  - Lazy Init
- (UIAlertView *)processAlert
{
    if (!_processAlert) {
        _processAlert = [[UIAlertView alloc] initWithTitle:@"Confirming..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    }
    return _processAlert;
}

@end
