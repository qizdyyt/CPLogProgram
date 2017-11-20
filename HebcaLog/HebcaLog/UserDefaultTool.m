//
//  UserDefaultTool.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import "UserDefaultTool.h"
#import "AppDelegate.h"
@implementation UserDefaultTool

+ (BOOL)getUserLoginState
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loginState = [_userDefaults boolForKey: USER_DEFAULTS_USER_INFO];
    return loginState;
}
///更新用户登录状态
+ (void)upDateUserLoginState:(BOOL)login
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    [_userDefaults setBool:login forKey:USER_DEFAULTS_USER_INFO];
    [_userDefaults synchronize];
}

+ (void)recordPasswordToDefaults:(NSString *)password
{
    if (password == nil) {
        return;
    }
    
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    [_userDefaults setValue:password forKey:USER_DEFAULTS_PASSWORD];
    
    [_userDefaults synchronize];
}

+ (NSString *)getPasswordFromDefaults
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *password = [_userDefaults valueForKey:USER_DEFAULTS_PASSWORD];
    
    return password;
}
///保存用户信息到用户默认配置
+ (void)updateUserConfig:(HBUserConfig *)config
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.userConfig = config;
    
    [self recordUSerConfigToDefaults];
}

//保存用户信息到用户默认配置
+ (void)recordUSerConfigToDefaults
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    HBUserConfig *config = appDelegate.userConfig;
    if (config == nil) {
        return;
    }
    
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic =[NSMutableDictionary dictionaryWithDictionary:[_userDefaults objectForKey:USER_DEFAULTS_USER_CONFIG]];
    if (userInfoDic == nil) {
        userInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    NSMutableDictionary *userConfig = [[userInfoDic objectForKey:config.certCN] mutableCopy];
    if (userConfig == nil) {
        userConfig = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber *attendState = [NSNumber numberWithBool:config.attendState];
    [userConfig setObject:attendState forKey:@"attendState"];
    
    NSNumber *hasHeadImg = [NSNumber numberWithBool:config.hasHeadImg];
    [userConfig setObject:hasHeadImg forKey:@"hasHeadImg"];
    
    NSNumber *clientrole  = [NSNumber numberWithInteger:config.clientrole];
    [userConfig setObject:clientrole  forKey:@"clientrole"];
    
    [userConfig setObject:config.userId   forKey:@"userId"];
    [userConfig setObject:config.userName forKey:@"userName"];
    [userConfig setObject:config.deptId   forKey:@"deptId"];
    [userConfig setObject:config.deptName forKey:@"deptName"];
    [userConfig setObject:config.certCN   forKey:@"certCN"];
    if (config.lastUpdate) {
        [userConfig setObject:config.lastUpdate forKey:@"lastUpdate"];
    }
    
    HBLocation *location = config.location;
    if (location) {
        if (location.latitude) {
            [userConfig setObject:location.latitude forKey:@"latitude"];
        }
        if (location.longitude) {
            [userConfig setObject:location.longitude forKey:@"longitude"];
        }
        if (location.address) {
            [userConfig setObject:location.address forKey:@"address"];
        }
    }
    
    [userInfoDic setObject:[userConfig copy] forKey:config.certCN];
    
    [_userDefaults setObject:[userInfoDic copy] forKey:USER_DEFAULTS_USER_CONFIG];
    [_userDefaults synchronize];
}

+ (NSString *)getUserId
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.userConfig.userId;
}

+ (NSString *)getUserName
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.userConfig.userName;
}

+ (NSString *)getDeptId
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.userConfig.deptId;
}

+ (NSString *)getDeptName
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.userConfig.deptName;
}

+ (NSString *)getCertCN
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.userConfig.certCN;
}

///"单例初始化方法"
static UserDefaultTool *_instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
    
}

+(instancetype)shareUserDefaultTool
{
    return [[self alloc] init];
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
