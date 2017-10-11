//
//  HBLoginReply.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply -登录返回信息
@interface HBLoginReply : NSObject
@property (nonatomic, copy)NSString *userId;    //用户id
@property (nonatomic, copy)NSString *userName;  //用户名称
@property (nonatomic, copy)NSString *deptId;    //部门id
@property (nonatomic, copy)NSString *deptName;  //部门名称
@property (nonatomic, copy)NSString *clientRole; //客户端角色
@end
