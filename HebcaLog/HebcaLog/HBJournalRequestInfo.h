//
//  HBJournalRequestInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func getJournalList
//Input 日志请求信息
@interface HBJournalRequestInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, copy)NSString *date;      //日志终止日期
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end
