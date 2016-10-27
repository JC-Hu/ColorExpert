//
//  JCHUAdHelper.h
//  SHOW-iColor
//
//  Created by JC_Hu on 16/1/29.
//  Copyright © 2016年 Sixer.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GADInterstitial;

extern NSString *const AdRemovedNotificationName;


@interface JCHUAdHelper : NSObject

@property(nonatomic, strong) GADInterstitial *interstitial;


+ (instancetype)shareInstance;


- (void)prepare;

- (void)showInterstitialAd;

#pragma mark - 去广告相关
/// 是否应该显示广告
- (BOOL)shouldShowAd;

/// 是否已去除广告
- (BOOL)haveRemovedAd;

/// 是否开启好评去广告
- (BOOL)isRateAndRemoveAdOn;

/// 去除广告
- (void)removeAd;

#pragma mark - 好评去广告流程
- (void)processRateAndRemoveAd;


@end
