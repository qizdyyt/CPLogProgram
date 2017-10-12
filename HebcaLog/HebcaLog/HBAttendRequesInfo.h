//
//  HBAttendRequesInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: getAttendStatistics:
//Input -查询配置信息
@interface HBAttendRequesInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, copy)NSString *date;      //考勤截止日期（不传默认当月）
@property (nonatomic, assign)BOOL badonly;      //是否仅查看异常的考勤信息 NO-返回所有考勤信息 YES-仅返回异常的考勤信息。
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end
