//
//  HBPosition.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func sendPosition
//Input 用户位置信息
//Func1 getPositions
//Reply 获取到的用户位置信息
@interface HBPosition : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic,assign)NSInteger forcesend; //是否强制上传
@property (nonatomic, copy)NSString *username;  //用户姓名 Func1 返回参数
@property (nonatomic, copy)NSString *time;      //该点定位时间 Func1 返回参数
@end
