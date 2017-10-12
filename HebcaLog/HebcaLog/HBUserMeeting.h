//
//  HBUserMeeting.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func  getMeetList
//Reply
@interface HBUserMeeting : NSObject
@property (nonatomic, copy) NSArray *meetingList;   //会议列表
@property (nonatomic, copy) NSArray *users;         //发消息的用户列表
@property (nonatomic, copy) NSData *jsonData;       //服务端读取的JSON数据
@end
