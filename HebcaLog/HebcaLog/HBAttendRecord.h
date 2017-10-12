//
//  HBAttendRecord.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply_sub 打卡记录
@interface HBAttendRecord : NSObject
@property (nonatomic, copy)NSString *date;      //考勤日期
@property (nonatomic, copy)NSString *worktime;    //工作时长
@property (nonatomic, assign)BOOL isbad;        //是否考勤异常 NO-考勤正常 YES-考勤异常
@property (nonatomic, copy)NSMutableArray *attendlist;//打卡列表  打卡信息：HBAttendInfo *（出参）
@end
