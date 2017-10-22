//
//  HBUserConfig.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/22.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBLocation.h"
//用户配置信息
@interface HBUserConfig : NSObject

@property (nonatomic, assign)BOOL attendState; //上班状态：YES-上班； NO-下班；
@property (nonatomic, assign)BOOL hasHeadImg;  //是否有头像
@property (nonatomic, assign)NSInteger clientrole; //客户端角色 未使用
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *deptId;
@property (nonatomic, copy)NSString *deptName;
@property (nonatomic, copy)NSString *certCN;
@property (nonatomic, copy)NSString *lastUpdate;
@property (nonatomic, retain)HBLocation *location;

- (id)init;

@end
