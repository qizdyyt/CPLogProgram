//
//  HBUserConfig.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/22.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import "HBUserConfig.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation HBUserConfig : NSObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.clientrole = 0;
        self.userId     = nil;
        self.userName   = nil;
        self.deptId     = nil;
        self.deptName   = nil;
        self.certCN     = nil;
        
        HBLocation *location = [[HBLocation alloc] init];
        self.location = location;
    }
    
    return self;
}

-(void)registerToServer: (void (^) (bool isOK, NSString* msg))complete {
    // LeanCloud - 注册
    // https://leancloud.cn/docs/leanstorage_guide-objc.html#用户名和密码注册
    AVUser *user = [AVUser user];
    user.username = self.userName;
    user.password = self.password;
    user.mobilePhoneNumber = self.phoneNumber;
    user.email = self.Email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            complete(YES, @"注册成功");
        } else {
            complete(NO, [NSString stringWithFormat:@"注册失败%@", error]);
        }
    }];
}

-(void)login:(void (^)(bool, NSString *))complete {
    if (self.userName.length && self.password.length) {
        [AVUser logInWithUsernameInBackground:self.userName password:self.password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                complete(NO, [NSString stringWithFormat:@"登录失败%@", error]);
            } else {
                complete(YES, @"登录成功");
            }
        }];
    } else {
        complete(NO, [NSString stringWithFormat:@"登录失败,用户名或密码不完整"]);
    }
}

@end


