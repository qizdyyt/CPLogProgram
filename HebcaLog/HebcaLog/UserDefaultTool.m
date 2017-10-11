//
//  UserDefaultTool.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//
#define USER_DEFAULTS_USER_INFO @"HBMLOG_USER_INFO"
#define USER_LOGIN_STATE        @"HBMLog_LoginState"


#import "UserDefaultTool.h"

@implementation UserDefaultTool



+ (NSNumber *)getUserLoginState
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [_userDefaults objectForKey:USER_DEFAULTS_USER_INFO];
    if (!userInfo) {
        return nil;
    }
    NSNumber *loginState = [userInfo objectForKey:USER_LOGIN_STATE];
    
    return loginState;
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
