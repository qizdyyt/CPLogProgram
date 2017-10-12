//
//  HBJournalInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func writeJournal
//Input 日志信息
//Func1 getJournalList
//Reply_sub 获取到的日志信息
@interface HBJournalInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //登录用户id
@property (nonatomic, copy)NSString *content;   //日志内容
@property (nonatomic, copy)NSString *image;     //日志图片
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *costtime;  //耗费工时，保留字段，暂不使用
@property (nonatomic, copy)NSString *journalId; //日志id  func1-输出参数
@property (nonatomic, copy)NSString *userName;  //用户姓名 func1-输出参数
@property (nonatomic, copy)NSString *time;      //发布时间 func1-输出参数
@property (nonatomic, copy)NSMutableArray *replies; //消息回复 HBReply* func1-输出参数
@end
