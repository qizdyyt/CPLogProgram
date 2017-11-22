//
//  UserDefaultTool.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBUserConfig.h"
/********
 
 主要使用于用户各类信息从userdefault的读取和存储
 
 ********/
@interface UserDefaultTool : NSObject<NSCopying, NSMutableCopying>

+(instancetype) shareUserDefaultTool;
///获取用户登录状态
+ (BOOL)getUserLoginState;
///更新用户登录状态
+ (void)upDateUserLoginState:(BOOL)login;
///获取用户密码
+ (NSString *)getPasswordFromDefaults;
///获取用户密码
+ (void)recordPasswordToDefaults:(NSString *)password;

//获取用户信息
+ (void)loadUserConfigFromDefaults:(NSString *)certCN;
+ (void)updateUserConfig:(HBUserConfig *)userConfig;
+ (void)recordUSerConfigToDefaults;

+ (NSString *)getUserId;
+ (NSString *)getUserName;
+ (NSString *)getDeptId;
+ (NSString *)getDeptName;
+ (NSString *)getCertCN;

//获取用户打卡信息
+ (BOOL) getUserCheckStatus;
//更新用户打卡信息
+ (void) updateUserCheckStatus: (BOOL)status;


@end
