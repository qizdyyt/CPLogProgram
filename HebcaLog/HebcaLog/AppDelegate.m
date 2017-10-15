//
//  AppDelegate.m
//  HebcaLog
//
//  Created by 周超 on 15/1/23.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "AppDelegate.h"
//#import "HBMLogLoginViewController.h"
#import "HBHomepageViewController.h"
//#import "HBFirstOpenViewController.h"
#import "HBCommonUtil.h"
#import "HBServerInterface.h"

#import "HBMLogLoginViewController.h"
#import "HBRegistViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
//    HBUpdateInfo *updateInfo;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    g_mapManager = nil;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = nil;
    //增加根据已登录状态判断，打开登录界面，还是进入首页
    BOOL loginState = [[HBCommonUtil getUserLoginState] boolValue];
    if (loginState) {
        HBHomepageViewController *homepageVC = [[HBHomepageViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:homepageVC];
    }else {
        HBMLogLoginViewController *loginVC = [[HBMLogLoginViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:loginVC];

    }
    if (nav) {
        nav.navigationBar.tintColor = [UIColor blackColor];
        nav.navigationBar.translucent = false;
    }
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    //注册本地通知
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    /**** 这里把检查更新删除 ****/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL loginState = [[HBCommonUtil getUserLoginState] boolValue];
    if (loginState) {   //如果为登录状态，则将用户配置信息保存到用户默认配置里
        [HBCommonUtil recordUSerConfigToDefaults];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //记录登录状态到默认配置
    [HBCommonUtil recordConfiguration];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (!SYSTEM_VERSION_HIGHER(8.0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定时提醒" message:notification.alertBody delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定时提醒" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

/**** 这里把检查更新删除 ****/


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 100 &&  buttonIndex == 1) {
//        NSURL *downloadUrl = [NSURL URLWithString:updateInfo.downloadurl];
//        //NSURL *downloadUrl = [NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://dn-hebca-kuaiban.qbox.me/test.plist"];
//        [[UIApplication sharedApplication]openURL:downloadUrl];
//    }
//}

- (HBLocationService *)getLocationService
{
    if (_locationService == nil) {
        _locationService = [[HBLocationService alloc] init];
    }
    
    return _locationService;
}

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window.rootViewController.view cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

@end


