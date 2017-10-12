//
//  HBMeetRequestInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func  getMeetList
//Input 消息请求信息
@interface HBMeetRequestInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end
