//
//  HBAttendInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: attendAct:
//Input -考勤信息
//Func1: getLastAttendInfo:
//Reply -上次考勤信息
@interface HBAttendInfo : NSObject
@property (nonatomic, copy)NSString *userId;    //用户id （打卡函数入参）
//@property (nonatomic, copy)NSString *time;      //打卡时间 （获取上次打卡信息出参）
//@property (nonatomic, strong) NSDate *firstCheckTime;//第一次打卡时间
@property (nonatomic, strong) NSDate *lastCheckTime;//最后一次打卡时间
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //打卡地址
@property (nonatomic, assign) BOOL isChecked; //是否已经上班打卡
//@property (nonatomic, assign)NSInteger type;    //打卡类型 1-上班  2-下班

-(void) checkToService: (void (^)(BOOL isOK, NSString* msg))complete;
@end
