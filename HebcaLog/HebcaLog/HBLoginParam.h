//
//  HBLoginParam.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: loginWithParam
//Input -登录参数
@interface HBLoginParam : NSObject
@property (nonatomic, copy)NSString *cert;      //签名证书（base64编码）
@property (nonatomic, copy)NSString *random;    //随机串
@property (nonatomic, copy)NSString *randomSign;//签名后随机串
@property (nonatomic, copy)NSString *userName;  //用户名 绑定证书时使用，可以为空
@property (nonatomic, copy)NSString *password;  //密码，绑定证书时使用，可以为空
@property (nonatomic, copy)NSString *divid;     //单位ID
@property (nonatomic, copy)NSString *deviceId;  //设备串号 （用户名和证书、证书和设备串号 都是一一对应）
@property (nonatomic, copy)NSString *pkgVersion;//软件版本号
@end
