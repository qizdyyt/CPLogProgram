//
//  HBReply.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Reply_sub 接收到的回复消息
@interface HBReply : NSObject
@property (nonatomic, copy)NSString *msgid;     //消息ID
@property (nonatomic, copy)NSString *content;   //消息内容
@property (nonatomic, copy)NSString *senderid;  //回复者ID
@property (nonatomic, copy)NSString *sendername;//回复者姓名
@property (nonatomic, copy)NSString *time;      //发布时间
@end
