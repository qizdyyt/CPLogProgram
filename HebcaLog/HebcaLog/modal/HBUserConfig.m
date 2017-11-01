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

-(void)saveToServer {
    // LeanCloud - 注册
    // https://leancloud.cn/docs/leanstorage_guide-objc.html#用户名和密码注册
    AVUser *user = [AVUser user];
    user.username = self.userName;
    user.password = self.password;
    user.email = self.Email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        } else {
            NSLog(@"注册失败 %@", error);
        }
    }];
}

@end


