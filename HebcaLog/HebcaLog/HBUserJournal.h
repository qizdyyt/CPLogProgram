//
//  HBUserJournal.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func  getJrnlList
//Reply

@interface HBUserJournal : NSObject
@property (nonatomic, copy) NSArray *journalList;   //日志列表
@property (nonatomic, copy) NSArray *users;         //发日志的用户列表
@property (nonatomic, copy) NSData *jsonData;       //服务端读取的JSON数据
@end
