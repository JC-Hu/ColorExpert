//
//  AppDelegate.m
//  ColorExpert
//
//  Created by JC_Hu on 16/3/7.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MobClick.h"
#import <Google/Analytics.h>
#import "JCHUAdHelper.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [self setupUMAnalytics];
    
    [self setupGoogleAnalytics];
    
    [[JCHUAdHelper shareInstance] prepare];
    [JCHUAppHelper lauch];
    
    
////    UIColor *color = [self colorWithString:@"R231, G21, B11" formType:ColorFormRGB];
//    
//    UIColor *color = [UIColor colorWithString:@" 12ff1a." formType:ColorFormHex];
//
//    
//    NSLog(@"R:%@, G:%@, B:%@", color.RGBInfo.red, color.RGBInfo.green, color.RGBInfo.blue);
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    return [self application:application openURL:url options:@{}];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    if ([ColorExpertHelper productType] == ColorExpertProductTypeNormal) {

        NSUserDefaults *groupTempUserDefault = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_TEMP_CONTAINER_ID];
        
        NSString *json = [groupTempUserDefault objectForKey:@"json"];
        
        if (json.length) {
            
            ViewController *vc = (ViewController *)self.window.rootViewController;
            
            [vc showColorWithInfoDict:[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil]];
            
        }
    }
    

    return YES;
}



/// 设置友盟统计
- (void)setupUMAnalytics
{
    
    [MobClick startWithAppkey:[ColorExpertHelper UMAppKey] reportPolicy:BATCH   channelId:@""];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick setCrashReportEnabled:NO];
    
}


/// 设置谷歌分析
- (void)setupGoogleAnalytics
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    //    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    NSLog(@"%@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // Enable Advertising Features.
    tracker.allowIDFACollection = YES;
}


@end
