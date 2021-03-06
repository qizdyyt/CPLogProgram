//
//  DEL_AppDelegate.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

//#import "AppDelegate.h"
//#import "HBMLogLoginViewController.h"
//#import "HBHomepageViewController.h"
//#import "HBFirstOpenViewController.h"
//#import "HBCommonUtil.h"
//#import "HBServerInterface.h"
//
//@interface AppDelegate ()
//
//@end
//
//@implementation AppDelegate
//{
//    HBUpdateInfo *updateInfo;
//}
//
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    g_mapManager = nil;
//    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UINavigationController *nav = nil;
//    
//    //如果没有证书，则直接跳转到首次登陆界面
//    NSArray *certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
//    if (0 == [certList count]) {
//        HBFirstOpenViewController *registVC = [[HBFirstOpenViewController alloc] init];
//        registVC.window = self.window;
//        nav = [[UINavigationController alloc] initWithRootViewController:registVC];
//        self.window.rootViewController = nav;
//    }
//    else {
//        //增加根据已登录状态判断，打开登录界面，还是进入首页
//        BOOL loginState = [[HBCommonUtil getUserLoginState] boolValue];
//        if (loginState) {
//            //加载用户默认配置
//            NSString *certCN = [HBCommonUtil getUserLoginCert];
//            [HBCommonUtil loadUserConfigFromDefaults:certCN];
//            
//            HBHomepageViewController *homepageVC = [[HBHomepageViewController alloc] init];
//            nav = [[UINavigationController alloc] initWithRootViewController:homepageVC];
//            
//            self.window.rootViewController = nav;
//        }
//        else {
//            HBMLogLoginViewController *loginViewController = [[HBMLogLoginViewController alloc] init];
//            loginViewController.window = self.window;
//            self.window.rootViewController = loginViewController;
//        }
//    }
//    
//    [self.window makeKeyAndVisible];
//    
//    //注册本地通知
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
//    
//    //检查更新
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *currVersion = [HBCommonUtil getAppBuildVersion];
//        
//        HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//        updateInfo = [serverConnect checkUpdate:currVersion];
//        if (updateInfo && updateInfo.isupdate) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showUpdateAlert];
//            });
//        }
//    });
//    
//    return YES;
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    
//    BOOL loginState = [[HBCommonUtil getUserLoginState] boolValue];
//    if (loginState) {   //如果为登录状态，则将用户配置信息保存到用户默认配置里
//        [HBCommonUtil recordUSerConfigToDefaults];
//    }
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    
//    //记录登录状态到默认配置
//    [HBCommonUtil recordConfiguration];
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    if (!SYSTEM_VERSION_HIGHER(8.0))
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定时提醒" message:notification.alertBody delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//        [alert show];
//    }
//    else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定时提醒" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:okAction];
//        
//        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    }
//}
//
//- (void)showUpdateAlert
//{
//    NSString *updateMsg = [NSString stringWithFormat:@"发现新版本，是否现在升级？\n更新说明：\n%@", updateInfo.updateDesc];
//    if (SYSTEM_VERSION_HIGHER(8.0)) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示"
//                                                                                 message:updateMsg
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            NSURL *downloadUrl = [NSURL URLWithString:updateInfo.downloadurl];
//            //NSURL *downloadUrl = [NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://dn-hebca-kuaiban.qbox.me/test1.plist"];
//            [[UIApplication sharedApplication]openURL:downloadUrl];
//            
//            //退出前保存默认配置
//            [HBCommonUtil recordConfiguration];
//            
//            [self exitApplication];
//        }];
//        [alertController addAction:okAction];
//        
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
//    else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示"
//                                                            message:updateMsg
//                                                           delegate:self
//                                                  cancelButtonTitle:@"以后再说"
//                                                  otherButtonTitles:@"升级", nil];
//        alertView.tag = 100;
//        
//        [alertView show];
//    }
//}
//
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 100 &&  buttonIndex == 1) {
//        NSURL *downloadUrl = [NSURL URLWithString:updateInfo.downloadurl];
//        //NSURL *downloadUrl = [NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://dn-hebca-kuaiban.qbox.me/test.plist"];
//        [[UIApplication sharedApplication]openURL:downloadUrl];
//    }
//}
//
//- (HBLocationService *)getLocationService
//{
//    if (_locationService == nil) {
//        _locationService = [[HBLocationService alloc] init];
//    }
//    
//    return _locationService;
//}
//
//- (void)exitApplication {
//    
//    [UIView beginAnimations:@"exitApplication" context:nil];
//    
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window.rootViewController.view cache:NO];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
//    
//    self.window.bounds = CGRectMake(0, 0, 0, 0);
//    
//    [UIView commitAnimations];
//    
//}
//
//- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//    
//    if ([animationID compare:@"exitApplication"] == 0) {
//        exit(0);
//    }
//}
//
//@end

