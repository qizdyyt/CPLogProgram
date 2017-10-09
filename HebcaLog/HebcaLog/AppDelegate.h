//
//  AppDelegate.h
//  HebcaLog
//
//  Created by 周超 on 15/1/23.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCommonUtil.h"
#import <BaiduMapAPI/BMapKit.h>
#import "HBLocationService.h"

BMKMapManager* g_mapManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HBUserConfig *userConfig;
@property (strong, nonatomic) UINavigationController *rootViewController;
@property (strong, nonatomic) HBLocationService *locationService;

- (HBLocationService *)getLocationService;

@end
