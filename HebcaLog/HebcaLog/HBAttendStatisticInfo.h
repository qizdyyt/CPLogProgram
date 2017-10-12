//
//  HBAttendStatisticInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply -考勤统计数据
@interface HBAttendStatisticInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //打卡人
@property (nonatomic, copy)NSString *userName;  //打卡人姓名
@property (nonatomic, assign)NSInteger baddays; //本月考勤异常天数
@property (nonatomic, copy)NSMutableArray *records; //打卡记录 HBAttendRecord *
@end
