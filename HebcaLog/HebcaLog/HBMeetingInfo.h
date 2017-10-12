//
//  HBMeetingInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: sendMeeting:
//Input -待发送的消息信息
//Func1: getMeetingList
//Reply_sub 获取到的消息
@interface HBMeetingInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *content;   //会议内容
@property (nonatomic, copy)NSString *image;     //会议图片      -------------------------------?????
@property (nonatomic, copy)NSString *receivers;
@property (nonatomic, copy)NSString *meetingman; //与会人列表
@property (nonatomic, assign)NSInteger leavecount; //请假人数
@property (nonatomic, assign)NSInteger signcount;  //签到人数
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *meetid;    //会议id func1出参
@property (nonatomic, copy)NSString *time;      //发布时间 func1出参
@property (nonatomic, copy)NSMutableArray *replies; //消息回复列表 func1出参  -HBReply *
@end
