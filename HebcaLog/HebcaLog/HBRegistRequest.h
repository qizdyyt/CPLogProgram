//
//  HBRegistRequest.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func registUnit
//Input 注册信息
@interface HBRegistRequest : NSObject
@property (nonatomic, copy) NSString *username;     //用户登录名
@property (nonatomic, copy) NSString *password;     //密码
@property (nonatomic, copy) NSString *divname;      //单位名称
@property (nonatomic, copy) NSString *name;         //用户姓名
@property (nonatomic, copy) NSString *mobilephone;  //手机号
@property (nonatomic, copy) NSString *identitycard; //身份证号码
@property (nonatomic, copy) NSString *scertcn;      //已经存在的签名证书CN号
@property (nonatomic, copy) NSString *code;         //短信验证码
@end
