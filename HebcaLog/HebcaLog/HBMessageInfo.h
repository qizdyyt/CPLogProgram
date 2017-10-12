//
//  HBMessageInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: sendMsg:
//Input -待发送的消息信息
//Func1: getMsgList
//Reply_sub 获取到的消息
@interface HBMessageInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *content;   //消息内容
@property (nonatomic, copy)NSString *image;     //消息图片      -------------------------------?????
@property (nonatomic, copy)NSString *receivers; //接收人列表
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *msgid;     //消息id func1出参
@property (nonatomic, copy)NSString *time;      //发布时间 func1出参
@property (nonatomic, copy)NSMutableArray *replies; //消息回复列表 func1出参  -HBReply *
@end
