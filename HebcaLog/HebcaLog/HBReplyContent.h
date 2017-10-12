//
//  HBReplyContent.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func replyMsg
//Input 回复的消息内容
@interface HBReplyContent : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *replyid;   //被回复消息id
@property (nonatomic, copy)NSString *replyto;
@property (nonatomic, copy)NSString *content;   //回复内容
@end
