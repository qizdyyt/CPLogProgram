//
//  UserDefaultTool.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import "UserDefaultTool.h"

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
