//
//  HBContact.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBContactDept.h"
//Reply_sub
@interface HBContact : NSObject
@property (nonatomic, copy) NSString *userid;    //用户id
@property (nonatomic, copy) NSString *username;  //用户姓名
@property (nonatomic, copy) NSString *phone;     //手机号码
@property (nonatomic, copy) NSString *telephone;     //坐机号码
@property (nonatomic, copy) NSString *extension;     //分机号码


@property (nonatomic, strong) HBContactDept * parentGroup;    //上级分组
@property (nonatomic, assign) BOOL selected;     //该组是否为选中状态
@end
