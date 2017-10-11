//
//  HBUserInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBUserInfo : NSObject

@property (nonatomic, copy)NSString *userId;    //用户id
@property (nonatomic, copy)NSString *userName;  //用户名称
@property (nonatomic, copy)NSString *phone;     //手机号
@property (nonatomic, copy)NSString *idNum;     //身份证号
@property (nonatomic, copy)NSString *divname;   //单位名称
@property (nonatomic, copy)NSString *certCN;    //已绑定的证书CN号，未绑定时为空串

@end
