//
//  UserDefaultTool.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
/********
 
 主要使用于用户各类信息从userdefault的读取和存储
 
 ********/
@interface UserDefaultTool : NSObject<NSCopying, NSMutableCopying>

+(instancetype) shareUserDefaultTool;
///获取用户登录状态
+ (BOOL)getUserLoginState;
///
+ (void)upDateUserLoginState:(BOOL)login;

+ (NSString *)getPasswordFromDefaults;
+ (void)recordPasswordToDefaults:(NSString *)password;


@end
