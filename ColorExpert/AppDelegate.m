//
//  AppDelegate.m
//  ColorExpert
//
//  Created by JC_Hu on 16/3/7.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <UMMobClick/MobClick.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import "FIRApp.h"
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
    UMConfigInstance.appKey =[ColorExpertHelper UMAppKey];
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick setCrashReportEnabled:NO];
}


/// 设置谷歌分析
- (void)setupGoogleAnalytics
{
    [FIRApp configure];
}


@end
