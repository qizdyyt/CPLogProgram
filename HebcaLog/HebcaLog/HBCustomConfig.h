//
//  HBCustomConfig.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func uploadCustomConfig
//Input 上传注册信息
@interface HBCustomConfig : NSObject
@property (nonatomic, copy) NSString *userid;       //用户ID
@property (nonatomic, copy) NSString *key;          //参数标识
@property (nonatomic, copy) NSString *value;        //参数值（若参数为文件类型（如设置用户头像），则此字段为空）
@property (nonatomic, copy) NSString *attachment;   //附件（上传文件时使用, 所填值为文件保存路径）
@property (nonatomic, copy) NSString *descript;     //参数描述
@end
